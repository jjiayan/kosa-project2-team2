package kr.or.kosa.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.UserDto;
import kr.or.kosa.dto.user.MyBoardItemDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class UserDao {

    /* ===== 가입 INSERT 분리 ===== */

    /** 일반가입: auth 컬럼 없이 INSERT */
    public int insertLocalUser(UserDto user) throws Exception {
        String sql =
            "INSERT INTO \"USER\" (" +
            "  user_login_id, user_pw, user_status, user_nickname, " +
            "  user_bio, user_phonenumber, user_photo, age_group, CREATED_AT" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUser_login_id());
            pstmt.setString(2, user.getUser_pw());        // not null (일반가입)
            pstmt.setString(3, user.getUser_status());
            pstmt.setString(4, user.getUser_nickname());
            pstmt.setString(5, user.getUser_bio());
            pstmt.setString(6, user.getUser_phonenumber());
            pstmt.setString(7, user.getUser_photo());
            if (user.getAge_group() == 0) pstmt.setNull(8, Types.INTEGER);
            else pstmt.setInt(8, user.getAge_group());
            return pstmt.executeUpdate();
        }
    }

    /** 소셜가입: auth_provider, auth_id 포함 INSERT (비번 null 허용 가능) */
    public int insertSocialUser(UserDto user) throws Exception {
        String sql =
            "INSERT INTO \"USER\" (" +
            "  user_login_id, user_pw, user_status, user_nickname, " +
            "  user_bio, user_phonenumber, user_photo, age_group, " +
            "  auth_provider, auth_id, CREATED_AT" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUser_login_id());
            if (user.getUser_pw() == null || user.getUser_pw().isEmpty())
                pstmt.setNull(2, Types.VARCHAR);
            else
                pstmt.setString(2, user.getUser_pw());
            pstmt.setString(3, user.getUser_status());
            pstmt.setString(4, user.getUser_nickname());
            pstmt.setString(5, user.getUser_bio());
            pstmt.setString(6, user.getUser_phonenumber());
            pstmt.setString(7, user.getUser_photo());
            if (user.getAge_group() == 0) pstmt.setNull(8, Types.INTEGER);
            else pstmt.setInt(8, user.getAge_group());
            pstmt.setString(9, user.getAuth_provider());  // "kakao"
            pstmt.setString(10, user.getAuth_id());       // kakao user id
            return pstmt.executeUpdate();
        }
    }

    /** 소셜: (provider, authId)로 사용자 조회 */
    public UserDto findByAuth(String provider, String authId) throws Exception {
        String sql = "SELECT user_id, user_login_id, user_pw, user_status, " +
                " user_nickname, user_bio, user_phonenumber, user_photo, " +
                " age_group, CREATED_AT, auth_provider, auth_id " +
                " FROM \"USER\" WHERE auth_provider = ? AND auth_id = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, provider);
            ps.setString(2, authId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        }
        return null;
    }

    /* ====== 기존 메서드들 (DELETED 제외 조건 유지) ====== */

    public int findUserByLoginId(String loginId) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_login_id = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, loginId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int findUserByNickName(String nickname) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_nickname = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nickname);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int findUserByPhoneNumber(String phoneDigits) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_phonenumber = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, phoneDigits);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public String findLoginIdByPhone(String phoneOnlyDigits) throws Exception {
        String sql = "SELECT user_login_id FROM \"USER\" WHERE user_phonenumber = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneOnlyDigits);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("user_login_id");
            }
        }
        return null;
    }

    public boolean existsByLoginIdAndPhone(String loginId, String phoneOnlyDigits) throws Exception {
        String sql = "SELECT 1 FROM \"USER\" WHERE user_login_id = ? AND user_phonenumber = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginId);
            ps.setString(2, phoneOnlyDigits);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public int updatePasswordByLoginId(String loginId, String encPw) throws Exception {
        String sql = "UPDATE \"USER\" SET user_pw = ? WHERE user_login_id = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encPw);
            ps.setString(2, loginId);
            return ps.executeUpdate();
        }
    }

    public UserDto findByLoginId(String loginId) throws Exception {
        String sql =
            "SELECT user_id, user_login_id, user_pw, user_status, " +
            "       user_nickname, user_bio, user_phonenumber, user_photo, " +
            "       age_group, CREATED_AT, auth_provider, auth_id " +
            "FROM \"USER\" WHERE user_login_id = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        }
        return null;
    }

    public UserDto findById(int userId) throws Exception {
        String sql =
            "SELECT user_id, user_login_id, user_pw, user_status, " +
            "       user_nickname, user_bio, user_phonenumber, user_photo, " +
            "       age_group, CREATED_AT, auth_provider, auth_id " +
            "FROM \"USER\" WHERE user_id = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        }
        return null;
    }

    public int updateUserProfileById(int userId,
                                     String nickname,
                                     String bio,
                                     String phoneDigits,
                                     Boolean setPhoto,
                                     String photoUrl,
                                     Integer ageGroup) throws Exception {

        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE \"USER\" SET ")
          .append(" user_nickname = ?, ")
          .append(" user_bio = ?, ")
          .append(" user_phonenumber = ? ");

        if (setPhoto != null) sb.append(", user_photo = ? ");
        if (ageGroup != null) sb.append(", age_group = ? ");

        sb.append(" WHERE user_id = ? AND user_status <> 'DELETED'");

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            int idx = 1;
            ps.setString(idx++, nickname);
            ps.setString(idx++, bio);
            if (phoneDigits == null || phoneDigits.isBlank()) ps.setNull(idx++, Types.VARCHAR);
            else ps.setString(idx++, phoneDigits);
            if (setPhoto != null) {
                if (photoUrl == null || photoUrl.isBlank()) ps.setNull(idx++, Types.VARCHAR);
                else ps.setString(idx++, photoUrl);
            }
            if (ageGroup != null) ps.setInt(idx++, ageGroup);
            ps.setInt(idx, userId);
            return ps.executeUpdate();
        }
    }

    public int updateUserPasswordById(int userId, String encPw) throws Exception {
        String sql = "UPDATE \"USER\" SET user_pw = ? WHERE user_id = ? AND user_status <> 'DELETED'";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encPw);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        }
    }

    /* ===== 공용 매퍼: auth 컬럼 포함 ===== */
    private UserDto mapUser(ResultSet rs) throws Exception {
        UserDto u = new UserDto();
        u.setUser_id(rs.getInt("user_id"));
        u.setUser_login_id(rs.getString("user_login_id"));
        u.setUser_pw(rs.getString("user_pw"));
        u.setUser_status(rs.getString("user_status"));
        u.setUser_nickname(rs.getString("user_nickname"));
        u.setUser_bio(rs.getString("user_bio"));
        u.setUser_phonenumber(rs.getString("user_phonenumber"));
        u.setUser_photo(rs.getString("user_photo"));

        int age = rs.getInt("age_group");
        if (rs.wasNull()) age = 0;
        u.setAge_group(age);

        Timestamp ts = rs.getTimestamp("CREATED_AT");
        if (ts != null) u.setCreatedAt(new java.util.Date(ts.getTime()));

        try { u.setAuth_provider(rs.getString("auth_provider")); } catch (SQLException ignore) {}
        try { u.setAuth_id(rs.getString("auth_id")); } catch (SQLException ignore) {}
        return u;
    }

    /* ===== (생략) 내가 쓴 글 목록/카운트 등 기존 메서드들 유지 ===== */
}
