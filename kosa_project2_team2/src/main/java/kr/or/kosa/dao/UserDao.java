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
    
    public UserDto findByNickname(String nickname) throws Exception {
        String sql = "SELECT user_id, user_login_id, user_nickname, user_photo " +
                     "FROM \"USER\" WHERE user_nickname = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, nickname);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    UserDto dto = new UserDto();
                    dto.setUser_id(rs.getInt("user_id"));
                    dto.setUser_login_id(rs.getString("user_login_id"));
                    dto.setUser_nickname(rs.getString("user_nickname"));
                    dto.setUser_photo(rs.getString("user_photo"));
                    return dto;
                }
            }
        }
        return null;
    }

    /** 아이디 찾기: 휴대폰 번호로 단일 로그인ID 조회 */
    public String findLoginIdByPhone(String phoneOnlyDigits) throws Exception {
        String sql = "SELECT user_login_id FROM \"USER\" WHERE user_phonenumber = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phoneOnlyDigits);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("user_login_id");
                }
            }
        }
        return null; // 없으면 null
    }
    
    public boolean existsByLoginIdAndPhone(String loginId, String phoneOnlyDigits) throws Exception {
        String sql = "SELECT 1 FROM \"USER\" WHERE user_login_id = ? AND user_phonenumber = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginId);
            ps.setString(2, phoneOnlyDigits);
            try (ResultSet rs = ps.executeQuery()) {
            	boolean next = rs.next();
                return next;
            }
        }
    }
    
 // 비밀번호 업데이트
    public int updatePasswordByLoginId(String loginId, String encPw) throws Exception {
        String sql = "UPDATE \"USER\" SET user_pw = ? WHERE user_login_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
        		PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encPw);
            ps.setString(2, loginId);
            return ps.executeUpdate();
        }
    }
    
    public UserDto findByLoginId(String loginId) throws Exception {
        String sql = "SELECT user_id, user_login_id, user_pw, user_status, " +
                     "       user_nickname, user_bio, user_phonenumber, user_photo " +
                     "FROM \"USER\" WHERE user_login_id = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
        		PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserDto dto = new UserDto();
                    dto.setUser_id(rs.getInt("user_id"));
                    dto.setUser_login_id(rs.getString("user_login_id"));
                    dto.setUser_pw(rs.getString("user_pw"));           // 비교용
                    dto.setUser_status(rs.getString("user_status"));   // 상태 체크용
                    dto.setUser_nickname(rs.getString("user_nickname"));
                    dto.setUser_bio(rs.getString("user_bio"));
                    dto.setUser_phonenumber(rs.getString("user_phonenumber"));
                    dto.setUser_photo(rs.getString("user_photo"));
                    return dto;
                }
            }
        }
        return null;
    }
    
}