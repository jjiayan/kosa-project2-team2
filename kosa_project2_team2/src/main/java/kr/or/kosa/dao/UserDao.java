package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class UserDao {

    public int insertUser(UserDto user) throws Exception {
        String sql = "INSERT INTO \"USER\" "
                   + "(user_login_id, user_pw, user_status, user_nickname, "
                   + "user_bio, user_phonenumber, user_photo) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUser_login_id());
            pstmt.setString(2, user.getUser_pw());
            pstmt.setString(3, user.getUser_status());
            pstmt.setString(4, user.getUser_nickname());
            pstmt.setString(5, user.getUser_bio());
            pstmt.setString(6, user.getUser_phonenumber());
            pstmt.setString(7, user.getUser_photo());

            return pstmt.executeUpdate();
        }
    }
    
    /** 아이디 중복 확인 */
    public int findUserByLoginId(String loginId) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_login_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, loginId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // 존재하면 1 이상
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // 오류나 없을 경우 0
    }
    /** 닉네임 중복 확인 */
    public int findUserByNickName(String nickname) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_nickname = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nickname);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 전화번호 중복 확인 */
    public int findUserByPhoneNumber(String phone) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_phonenumber = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, phone);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
}