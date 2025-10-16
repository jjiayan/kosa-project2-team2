package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.kosa.dto.UserActivityDto;
import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class UserActivityDao {
    
    // 사용자 정보 조회 
    public UserDto getUserInfo(Long userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        UserDto user = null;
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            String sql = "SELECT USER_ID, USER_NICKNAME, USER_PHOTO, USER_STATUS, AGE_GROUP " +
                        "FROM \"USER\" WHERE USER_ID = ? AND USER_STATUS = 'ACTIVE'";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new UserDto();
                user.setUser_id(rs.getInt("USER_ID"));
                user.setUser_nickname(rs.getString("USER_NICKNAME"));
                user.setUser_photo(rs.getString("USER_PHOTO"));
                user.setUser_status(rs.getString("USER_STATUS"));
                user.setAge_group(rs.getInt("AGE_GROUP"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        return user;
    }
    
    // 모임방 정보 조회
    public Map<String, Object> getRoomInfo(Long roomId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Object> roomInfo = new HashMap<>();
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            String sql = "SELECT ROOM_TITLE FROM ROOM WHERE ROOM_ID = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, roomId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                roomInfo.put("roomTitle", rs.getString("ROOM_TITLE"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        return roomInfo;
    }
    
    // 사용자의 방 내 역할 조회 (room_tier 포함)
    public Map<String, String> getUserRoleInRoom(Long userId, Long roomId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, String> roleInfo = new HashMap<>();
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            
            // 먼저 방장인지 확인
            String leaderSql = "SELECT COUNT(*) FROM JOIN_ROOM WHERE ROOM_ID = ? AND USER_ID = ? AND ROOM_TIER = 'LEADER'";
            pstmt = conn.prepareStatement(leaderSql);
            pstmt.setLong(1, roomId);
            pstmt.setLong(2, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // 방장인 경우
                roleInfo.put("role", "LEADER");
                roleInfo.put("tier", "방장");
            } else {
                // 방장이 아닌 경우, JOIN_ROOM에서 티어 확인
                ConnectionPoolHelper.close(rs);
                ConnectionPoolHelper.close(pstmt);
                
                String memberSql = "SELECT ROOM_TIER FROM JOIN_ROOM WHERE ROOM_ID = ? AND USER_ID = ?";
                pstmt = conn.prepareStatement(memberSql);
                pstmt.setLong(1, roomId);
                pstmt.setLong(2, userId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    // JOIN_ROOM에 레코드가 있으면 승인된 멤버
                    String roomTier = rs.getString("ROOM_TIER");
                    roleInfo.put("role", "MEMBER");
                    roleInfo.put("tier", roomTier != null ? roomTier : "일반");
                } else {
                    // JOIN_ROOM에 없으면 방문자
                    roleInfo.put("role", "VISITOR");
                    roleInfo.put("tier", "방문자");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 기본값 설정
            roleInfo.put("role", "VISITOR");
            roleInfo.put("tier", "방문자");
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        return roleInfo;
    }
    
    // 나머지 메서드들은 기존과 동일하게 유지
    public Map<String, Object> getUserPosts(Long userId, Long roomId, int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UserActivityDto> activities = new ArrayList<>();
        int totalCount = 0;
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            
            // 총 개수 조회
            String countSql = "SELECT COUNT(*) FROM ROOM_BOARD rb " +
                             "JOIN ROOM r ON rb.ROOM_ID = r.ROOM_ID " +
                             "WHERE rb.USER_ID = ? AND rb.ROOM_ID = ? AND rb.IS_DELETED = 'N'";
            
            pstmt = conn.prepareStatement(countSql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            
            // 목록 조회
            String sql = "SELECT * FROM (" +
                        "SELECT rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, " +
                        "rb.ROOM_BOARD_TYPE, r.ROOM_TITLE, " +
                        "(SELECT COUNT(*) FROM LIKE_ROOM_BOARD lrb WHERE lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS LIKE_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.STATUS = 'ACTIVE') AS REPLY_COUNT, " +
                        "ROW_NUMBER() OVER (ORDER BY rb.CREATED_AT DESC) AS RN " +
                        "FROM ROOM_BOARD rb " +
                        "JOIN ROOM r ON rb.ROOM_ID = r.ROOM_ID " +
                        "WHERE rb.USER_ID = ? AND rb.ROOM_ID = ? AND rb.IS_DELETED = 'N'" +
                        ") WHERE RN BETWEEN ? AND ?";
            
            int offset = (page - 1) * pageSize;
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            pstmt.setInt(3, offset + 1);
            pstmt.setInt(4, offset + pageSize);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserActivityDto activity = UserActivityDto.builder()
                    .roomBoardId(rs.getLong("ROOM_BOARD_ID"))
                    .title(rs.getString("ROOM_BOARD_TITLE"))
                    .createdAt(rs.getTimestamp("CREATED_AT"))
                    .viewCount(rs.getInt("ROOM_BOARD_VIEW_CNT"))
                    .likeCount(rs.getInt("LIKE_COUNT"))
                    .replyCount(rs.getInt("REPLY_COUNT"))
                    .roomTitle(rs.getString("ROOM_TITLE"))
                    .boardType(rs.getString("ROOM_BOARD_TYPE"))
                    .activityType("POST")
                    .build();
                activities.add(activity);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("activities", activities);
        result.put("totalCount", totalCount);
        result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        return result;
    }
  
    // 사용자가 작성한 댓글 목록
    public Map<String, Object> getUserComments(Long userId, Long roomId, int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UserActivityDto> activities = new ArrayList<>();
        int totalCount = 0;
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            
            // 총 개수 조회
            String countSql = "SELECT COUNT(*) FROM REPLY r " +
                             "JOIN ROOM_BOARD rb ON r.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                             "WHERE r.USER_ID = ? AND rb.ROOM_ID = ? AND r.STATUS = 'ACTIVE' AND rb.IS_DELETED = 'N'";
            
            pstmt = conn.prepareStatement(countSql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            
            // 목록 조회
            String sql = "SELECT * FROM (" +
                        "SELECT r.REPLY_ID, r.REPLY_CONTENT, r.REPLY_CREATED_AT, " +
                        "rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rm.ROOM_TITLE, " +
                        "ROW_NUMBER() OVER (ORDER BY r.REPLY_CREATED_AT DESC) AS RN " +
                        "FROM REPLY r " +
                        "JOIN ROOM_BOARD rb ON r.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                        "JOIN ROOM rm ON rb.ROOM_ID = rm.ROOM_ID " +
                        "WHERE r.USER_ID = ? AND rb.ROOM_ID = ? AND r.STATUS = 'ACTIVE' AND rb.IS_DELETED = 'N'" +
                        ") WHERE RN BETWEEN ? AND ?";
            
            int offset = (page - 1) * pageSize;
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            pstmt.setInt(3, offset + 1);
            pstmt.setInt(4, offset + pageSize);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserActivityDto activity = UserActivityDto.builder()
                    .replyId(rs.getLong("REPLY_ID"))
                    .roomBoardId(rs.getLong("ROOM_BOARD_ID"))
                    .title(rs.getString("ROOM_BOARD_TITLE"))
                    .content(rs.getString("REPLY_CONTENT"))
                    .createdAt(rs.getTimestamp("REPLY_CREATED_AT"))
                    .roomTitle(rs.getString("ROOM_TITLE"))
                    .activityType("COMMENT")
                    .build();
                activities.add(activity);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("activities", activities);
        result.put("totalCount", totalCount);
        result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        return result;
    }
    
    // 사용자가 댓글을 단 게시글 목록
    public Map<String, Object> getUserCommentedPosts(Long userId, Long roomId, int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UserActivityDto> activities = new ArrayList<>();
        int totalCount = 0;
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            
            // 총 개수 조회 (중복 제거)
            String countSql = "SELECT COUNT(DISTINCT rb.ROOM_BOARD_ID) FROM REPLY r " +
                             "JOIN ROOM_BOARD rb ON r.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                             "WHERE r.USER_ID = ? AND rb.ROOM_ID = ? AND r.STATUS = 'ACTIVE' AND rb.IS_DELETED = 'N'";
            
            pstmt = conn.prepareStatement(countSql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            
            // 목록 조회 (작성자 닉네임 추가)
            String sql = "SELECT * FROM (" +
                        "SELECT DISTINCT rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, " +
                        "rm.ROOM_TITLE, u.USER_NICKNAME AS AUTHOR_NICKNAME, " +
                        "(SELECT COUNT(*) FROM LIKE_ROOM_BOARD lrb WHERE lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS LIKE_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.STATUS = 'ACTIVE') AS REPLY_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.USER_ID = ? AND rep.STATUS = 'ACTIVE') AS MY_REPLY_COUNT, " +
                        "ROW_NUMBER() OVER (ORDER BY MAX(r.REPLY_CREATED_AT) DESC) AS RN " +
                        "FROM REPLY r " +
                        "JOIN ROOM_BOARD rb ON r.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                        "JOIN ROOM rm ON rb.ROOM_ID = rm.ROOM_ID " +
                        "JOIN \"USER\" u ON rb.USER_ID = u.USER_ID " +
                        "WHERE r.USER_ID = ? AND rb.ROOM_ID = ? AND r.STATUS = 'ACTIVE' AND rb.IS_DELETED = 'N' " +
                        "GROUP BY rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, rm.ROOM_TITLE, u.USER_NICKNAME" +
                        ") WHERE RN BETWEEN ? AND ?";
            
            int offset = (page - 1) * pageSize;
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, userId);
            pstmt.setLong(3, roomId);
            pstmt.setInt(4, offset + 1);
            pstmt.setInt(5, offset + pageSize);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserActivityDto activity = UserActivityDto.builder()
                    .roomBoardId(rs.getLong("ROOM_BOARD_ID"))
                    .title(rs.getString("ROOM_BOARD_TITLE"))
                    .createdAt(rs.getTimestamp("CREATED_AT"))
                    .viewCount(rs.getInt("ROOM_BOARD_VIEW_CNT"))
                    .likeCount(rs.getInt("LIKE_COUNT"))
                    .replyCount(rs.getInt("MY_REPLY_COUNT"))
                    .roomTitle(rs.getString("ROOM_TITLE"))
                    .authorNickname(rs.getString("AUTHOR_NICKNAME"))
                    .activityType("COMMENTED_POST")
                    .build();
                activities.add(activity);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("activities", activities);
        result.put("totalCount", totalCount);
        result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        return result;
    }
    
    // 사용자가 좋아요한 게시글 목록
    public Map<String, Object> getUserLikedPosts(Long userId, Long roomId, int page, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UserActivityDto> activities = new ArrayList<>();
        int totalCount = 0;
        
        try {
            conn = ConnectionPoolHelper.getConnection();
            
            // 총 개수 조회
            String countSql = "SELECT COUNT(*) FROM LIKE_ROOM_BOARD lrb " +
                             "JOIN ROOM_BOARD rb ON lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                             "WHERE lrb.USER_ID = ? AND rb.ROOM_ID = ? AND rb.IS_DELETED = 'N'";
            
            pstmt = conn.prepareStatement(countSql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            
            // 목록 조회 (작성자 닉네임 추가)
            String sql = "SELECT * FROM (" +
                        "SELECT rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, " +
                        "rm.ROOM_TITLE, lrb.LIKE_CREATED_AT, u.USER_NICKNAME AS AUTHOR_NICKNAME, " +
                        "(SELECT COUNT(*) FROM LIKE_ROOM_BOARD lrb2 WHERE lrb2.ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS LIKE_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.STATUS = 'ACTIVE') AS REPLY_COUNT, " +
                        "ROW_NUMBER() OVER (ORDER BY lrb.LIKE_CREATED_AT DESC) AS RN " +
                        "FROM LIKE_ROOM_BOARD lrb " +
                        "JOIN ROOM_BOARD rb ON lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                        "JOIN ROOM rm ON rb.ROOM_ID = rm.ROOM_ID " +
                        "JOIN \"USER\" u ON rb.USER_ID = u.USER_ID " +
                        "WHERE lrb.USER_ID = ? AND rb.ROOM_ID = ? AND rb.IS_DELETED = 'N'" +
                        ") WHERE RN BETWEEN ? AND ?";
            
            int offset = (page - 1) * pageSize;
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            pstmt.setLong(2, roomId);
            pstmt.setInt(3, offset + 1);
            pstmt.setInt(4, offset + pageSize);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserActivityDto activity = UserActivityDto.builder()
                    .roomBoardId(rs.getLong("ROOM_BOARD_ID"))
                    .title(rs.getString("ROOM_BOARD_TITLE"))
                    .createdAt(rs.getTimestamp("CREATED_AT"))
                    .likeCreatedAt(rs.getTimestamp("LIKE_CREATED_AT"))
                    .viewCount(rs.getInt("ROOM_BOARD_VIEW_CNT"))
                    .likeCount(rs.getInt("LIKE_COUNT"))
                    .replyCount(rs.getInt("REPLY_COUNT"))
                    .roomTitle(rs.getString("ROOM_TITLE"))
                    .authorNickname(rs.getString("AUTHOR_NICKNAME"))
                    .activityType("LIKED_POST")
                    .build();
                activities.add(activity);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("activities", activities);
        result.put("totalCount", totalCount);
        result.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        
        return result;
    }
}