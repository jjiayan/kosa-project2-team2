package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;

import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class UserDao {

    /** 회원가입: CREATED_AT은 SYSDATE로 명시 입력 */
	public int insertUser(UserDto user) throws Exception {
	    String sql =
	        "INSERT INTO \"USER\" (" +
	        "  user_login_id, user_pw, user_status, user_nickname, " +
	        "  user_bio, user_phonenumber, user_photo, age_group, CREATED_AT" +
	        ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)";
	    try (Connection conn = ConnectionPoolHelper.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, user.getUser_login_id());
	        pstmt.setString(2, user.getUser_pw());
	        pstmt.setString(3, user.getUser_status());
	        pstmt.setString(4, user.getUser_nickname());
	        pstmt.setString(5, user.getUser_bio());
	        pstmt.setString(6, user.getUser_phonenumber());
	        pstmt.setString(7, user.getUser_photo());
	        pstmt.setInt(8, user.getAge_group());  // ✅ int로 저장
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
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** 닉네임 중복 확인 */
    public int findUserByNickName(String nickname) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_nickname = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, nickname);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** 전화번호 중복 확인 */
    public int findUserByPhoneNumber(String phoneDigits) {
        String sql = "SELECT COUNT(*) FROM \"USER\" WHERE user_phonenumber = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, phoneDigits);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** 닉네임으로 간단 조회 (createdAt 포함) — age_group는 필요 없어서 생략해도 OK */
    public UserDto findByNickname(String nickname) throws Exception {
        String sql =
            "SELECT user_id, user_login_id, user_nickname, user_photo, CREATED_AT " +
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
                    java.sql.Timestamp ts = rs.getTimestamp("CREATED_AT");
                    if (ts != null) dto.setCreatedAt(new java.util.Date(ts.getTime()));
                    return dto;
                }
            }
        }
        return null;
    }

    /** 휴대폰(숫자만)으로 로그인 ID 찾기 */
    public String findLoginIdByPhone(String phoneOnlyDigits) throws Exception {
        String sql = "SELECT user_login_id FROM \"USER\" WHERE user_phonenumber = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneOnlyDigits);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("user_login_id");
            }
        }
        return null;
    }

    /** 아이디+휴대폰 매칭 여부 */
    public boolean existsByLoginIdAndPhone(String loginId, String phoneOnlyDigits) throws Exception {
        String sql = "SELECT 1 FROM \"USER\" WHERE user_login_id = ? AND user_phonenumber = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginId);
            ps.setString(2, phoneOnlyDigits);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** 비밀번호 업데이트 (loginId 기준) */
    public int updatePasswordByLoginId(String loginId, String encPw) throws Exception {
        String sql = "UPDATE \"USER\" SET user_pw = ? WHERE user_login_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encPw);
            ps.setString(2, loginId);
            return ps.executeUpdate();
        }
    }

    /** 로그인용 (loginId 기준 상세 조회) — createdAt/age_group 포함 */
    public UserDto findByLoginId(String loginId) throws Exception {
        String sql =
            "SELECT user_id, user_login_id, user_pw, user_status, " +
            "       user_nickname, user_bio, user_phonenumber, user_photo, " +
            "       age_group, CREATED_AT " +                    // ✅ 포함
            "FROM \"USER\" WHERE user_login_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        }
        return null;
    }

    /** PK로 상세 조회 — createdAt/age_group 포함 */
    public UserDto findById(int userId) throws Exception {
        String sql =
            "SELECT user_id, user_login_id, user_pw, user_status, " +
            "       user_nickname, user_bio, user_phonenumber, user_photo, " +
            "       age_group, CREATED_AT " +                    // ✅ 포함
            "FROM \"USER\" WHERE user_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapUser(rs);
            }
        }
        return null;
    }

    /**
     * 프로필 업데이트 (사진 제어 포함)
     *  - setPhoto == null  : user_photo 컬럼 미변경
     *  - setPhoto == true  : photoUrl == null → NULL 저장(기본 이미지 의도)
     *                        photoUrl 값 존재 → URL 저장
     */
    public int updateUserProfileById(int userId,
                                     String nickname,
                                     String bio,
                                     String phoneDigits,
                                     Boolean setPhoto,
                                     String photoUrl) throws Exception {

        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE \"USER\" SET ")
          .append(" user_nickname = ?, ")
          .append(" user_bio = ?, ")
          .append(" user_phonenumber = ? ");

        if (setPhoto != null) {
            sb.append(", user_photo = ? ");
        }

        sb.append(" WHERE user_id = ?");

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            int idx = 1;

            // nickname
            ps.setString(idx++, nickname);

            // bio
            ps.setString(idx++, bio);

            // phoneDigits (null/blank → NULL)
            if (phoneDigits == null || phoneDigits.isBlank()) {
                ps.setNull(idx++, Types.VARCHAR);
            } else {
                ps.setString(idx++, phoneDigits);
            }

            // photo (옵션)
            if (setPhoto != null) {
                if (photoUrl == null || photoUrl.isBlank()) {
                    ps.setNull(idx++, Types.VARCHAR);
                } else {
                    ps.setString(idx++, photoUrl);
                }
            }

            // userId
            ps.setInt(idx, userId);

            return ps.executeUpdate();
        }
    }

    /** 비밀번호 업데이트 (userId 기준) */
    public int updateUserPasswordById(int userId, String encPw) throws Exception {
        String sql = "UPDATE \"USER\" SET user_pw = ? WHERE user_id = ?";
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encPw);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        }
    }

    // ========= 공용 매퍼 =========
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
        u.setAge_group(rs.getInt("age_group")); // ✅ 매핑

        java.sql.Timestamp ts = rs.getTimestamp("CREATED_AT");
        if (ts != null) u.setCreatedAt(new java.util.Date(ts.getTime()));

        return u;
    }
}
