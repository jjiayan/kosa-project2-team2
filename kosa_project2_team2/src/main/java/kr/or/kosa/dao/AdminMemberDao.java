package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class AdminMemberDao {

    // 전체 회원 수 구하기
    public int getUserCount() {
    	String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_status != 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 페이징된 회원 목록 가져오기
    public List<UserDto> getPagedUsers(int offset, int limit) {
        List<UserDto> userList = new ArrayList<>();

        String sql = 
            "SELECT user_id, user_login_id, user_status, user_nickname, user_phonenumber, user_photo " +
            "FROM \"USER\" " +
            "WHERE user_status != 'DELETED' " + 
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
                    userList.add(user);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return userList;
    }
    // 회원탈퇴 (user_status->DELETED)로 변경
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

}
