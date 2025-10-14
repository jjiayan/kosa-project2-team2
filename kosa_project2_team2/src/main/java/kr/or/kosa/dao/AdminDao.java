package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.AdminNoticeDto;
import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class AdminDao {
	//adminMember
	
	// 전체 회원 수 조회 
    public int getUserCount() {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_status NOT IN ('DELETED', 'ADMIN')";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 검색 포함 회원 수 조회
    public int getUserCount(String nickname) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_status NOT IN ('DELETED', 'ADMIN') AND user_nickname LIKE ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + nickname + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 전체 목록 조회
    public List<UserDto> getPagedUsers(int offset, int limit) {
        List<UserDto> userList = new ArrayList<>();
        String sql =
            "SELECT user_id, user_login_id, user_status, user_nickname, user_phonenumber, user_photo, user_bio, created_at " +
            "FROM \"USER\" " +
            "WHERE user_status NOT IN ('DELETED', 'ADMIN') " +
            "ORDER BY user_id " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, offset);
            pstmt.setInt(2, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UserDto user = new UserDto();
                    user.setUser_id(rs.getInt("user_id"));
                    user.setUser_login_id(rs.getString("user_login_id"));
                    user.setUser_status(rs.getString("user_status"));
                    user.setUser_nickname(rs.getString("user_nickname"));
                    user.setUser_phonenumber(rs.getString("user_phonenumber"));
                    user.setUser_photo(rs.getString("user_photo"));
                    user.setUser_bio(rs.getString("user_bio"));
                    user.setCreatedAt(rs.getDate("created_at")); 
                    userList.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // 검색 포함 목록 조회
    public List<UserDto> getPagedUsers(int offset, int limit, String nickname) {
        List<UserDto> userList = new ArrayList<>();
        String sql =
            "SELECT user_id, user_login_id, user_status, user_nickname, user_phonenumber, user_photo, user_bio, created_at " +
            "FROM \"USER\" " +
            "WHERE user_status NOT IN ('DELETED', 'ADMIN') AND user_nickname LIKE ? " +
            "ORDER BY user_id " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + nickname + "%");
            pstmt.setInt(2, offset);
            pstmt.setInt(3, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UserDto user = new UserDto();
                    user.setUser_id(rs.getInt("user_id"));
                    user.setUser_login_id(rs.getString("user_login_id"));
                    user.setUser_status(rs.getString("user_status"));
                    user.setUser_nickname(rs.getString("user_nickname"));
                    user.setUser_phonenumber(rs.getString("user_phonenumber"));
                    user.setUser_photo(rs.getString("user_photo"));
                    user.setUser_bio(rs.getString("user_bio"));
                    user.setCreatedAt(rs.getDate("created_at")); 
                    userList.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // 회원탈퇴
    public int deleteUser(int userId) {
        String sql = "UPDATE \"USER\" SET user_status = 'DELETED' WHERE user_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
	//adminNotice
    
    //  공지사항 총 개수 조회
    public int getNoticeCount() {
        String sql = "SELECT COUNT(*) FROM admin_notice WHERE is_deleted = 'N'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int updateNoticeViewCnt(int noticeId) {
        String sql = "UPDATE admin_notice SET view_cnt = view_cnt + 1 WHERE notice_id = ? AND is_deleted = 'N'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, noticeId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    //  공지사항 목록 조회 (페이징)
    public List<AdminNoticeDto> getPagedNotices(int offset, int limit) {
        List<AdminNoticeDto> noticeList = new ArrayList<>();
        String sql =
        	    "SELECT "
        	  + "notice_id AS adminNoticeId, "
        	  + "title AS adminNoticeTitle, " 
        	  + "created_at AS createdAt, "
        	  + "view_cnt AS adminNoticeViewCnt "
        	  + "FROM admin_notice "
        	  + "WHERE is_deleted = 'N' "
        	  + "ORDER BY notice_id DESC "
        	  + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";


        try (Connection conn = ConnectionPoolHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
               pstmt.setInt(1, offset);
               pstmt.setInt(2, limit);
               try (ResultSet rs = pstmt.executeQuery()) {
                   while (rs.next()) {
                       AdminNoticeDto dto = AdminNoticeDto.builder()
                               .adminNoticeId(rs.getInt("adminNoticeId"))
                               .adminNoticeTitle(rs.getString("adminNoticeTitle")) 
                               .createdAt(rs.getDate("createdAt"))
                               .adminNoticeViewCnt(rs.getInt("adminNoticeViewCnt"))
                               .build();
                       noticeList.add(dto);
                   }
               }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return noticeList;
    }


    
 // 공지사항 단건 조회 - 닉네임 join
    public AdminNoticeDto getNoticeById(int noticeId) {
    	
        String sql = 
            "SELECT " +
            "n.notice_id AS adminNoticeId, " +
            "n.title AS adminNoticeTitle, " +
            "n.content AS adminNoticeContent, " +
            "n.created_at AS createdAt, " +
            "n.view_cnt AS adminNoticeViewCnt, " +
            "u.user_nickname AS userNickname " +
            "FROM admin_notice n " +
            "JOIN \"USER\" u ON n.user_id = u.user_id " +
            "WHERE n.notice_id = ? AND n.is_deleted = 'N'";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, noticeId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return AdminNoticeDto.builder()
                            .adminNoticeId(rs.getInt("adminNoticeId"))
                            .adminNoticeTitle(rs.getString("adminNoticeTitle"))
                            .adminNoticeContent(rs.getString("adminNoticeContent"))
                            .createdAt(rs.getDate("createdAt"))
                            .adminNoticeViewCnt(rs.getInt("adminNoticeViewCnt"))
                            .userNickname(rs.getString("userNickname"))
                            .build();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    
    // 공지사항 작성
    public int insertNotice(String title, String content, int userId) {
    	String sql = "INSERT INTO admin_notice (title, content, created_at, user_id, is_deleted, view_cnt) "
    	           + "VALUES (?, ?, SYSDATE, ?, 'N', 0)";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setInt(3, userId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // 공지사항 수정
    public int updateNotice(int noticeId, String title, String content) {
        String sql = "UPDATE admin_notice "
                   + "SET title = ?, content = ? "
                   + "WHERE notice_id = ? AND is_deleted = 'N'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setInt(3, noticeId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 공지사항 삭제 
    public int deleteNotice(int noticeId) {
        String sql = "UPDATE admin_notice SET is_deleted = 'Y' WHERE notice_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, noticeId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
