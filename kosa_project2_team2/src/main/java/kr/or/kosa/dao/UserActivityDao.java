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
            String sql = "SELECT USER_ID, USER_NICKNAME, USER_PHOTO, USER_STATUS " +
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
    
    // 사용자가 작성한 게시글 목록
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
            
            // 목록 조회
            String sql = "SELECT * FROM (" +
                        "SELECT DISTINCT rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, " +
                        "rm.ROOM_TITLE, " +
                        "(SELECT COUNT(*) FROM LIKE_ROOM_BOARD lrb WHERE lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS LIKE_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.STATUS = 'ACTIVE') AS REPLY_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.USER_ID = ? AND rep.STATUS = 'ACTIVE') AS MY_REPLY_COUNT, " +
                        "ROW_NUMBER() OVER (ORDER BY MAX(r.REPLY_CREATED_AT) DESC) AS RN " +
                        "FROM REPLY r " +
                        "JOIN ROOM_BOARD rb ON r.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                        "JOIN ROOM rm ON rb.ROOM_ID = rm.ROOM_ID " +
                        "WHERE r.USER_ID = ? AND rb.ROOM_ID = ? AND r.STATUS = 'ACTIVE' AND rb.IS_DELETED = 'N' " +
                        "GROUP BY rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, rm.ROOM_TITLE" +
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
            
            // 목록 조회
            String sql = "SELECT * FROM (" +
                        "SELECT rb.ROOM_BOARD_ID, rb.ROOM_BOARD_TITLE, rb.CREATED_AT, rb.ROOM_BOARD_VIEW_CNT, " +
                        "rm.ROOM_TITLE, lrb.LIKE_CREATED_AT, " +
                        "(SELECT COUNT(*) FROM LIKE_ROOM_BOARD lrb2 WHERE lrb2.ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS LIKE_COUNT, " +
                        "(SELECT COUNT(*) FROM REPLY rep WHERE rep.ROOM_BOARD_ID = rb.ROOM_BOARD_ID AND rep.STATUS = 'ACTIVE') AS REPLY_COUNT, " +
                        "ROW_NUMBER() OVER (ORDER BY lrb.LIKE_CREATED_AT DESC) AS RN " +
                        "FROM LIKE_ROOM_BOARD lrb " +
                        "JOIN ROOM_BOARD rb ON lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
                        "JOIN ROOM rm ON rb.ROOM_ID = rm.ROOM_ID " +
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
                    .createdAt(rs.getTimestamp("LIKE_CREATED_AT"))
                    .viewCount(rs.getInt("ROOM_BOARD_VIEW_CNT"))
                    .likeCount(rs.getInt("LIKE_COUNT"))
                    .replyCount(rs.getInt("REPLY_COUNT"))
                    .roomTitle(rs.getString("ROOM_TITLE"))
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