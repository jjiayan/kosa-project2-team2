package kr.or.kosa.dto;

import java.util.Date;

public class UserDto {
    private int user_id;
    private String user_login_id;
    private String user_pw;            // 해시 저장
    private String user_status;        // ACTIVE / DELETED / ...
    private String user_nickname;
    private String user_bio;
    private String user_phonenumber;   // 숫자만(예: 01012345678) 권장
    private String user_photo;
    private int age_group;             // 10/20/30/40/50
    private Date createdAt;

    // 🔸 소셜 연동 필드
    private String auth_provider;      // 예: "kakao"
    private String auth_id;            // 예: "1234567890123" (카카오 user id)

    public UserDto() {
        this.createdAt = new Date();
    }

    public UserDto(int user_id, String user_login_id, String user_pw, String user_status,
                   String user_nickname, String user_bio, String user_phonenumber,
                   String user_photo, int age_group) {
        this.user_id = user_id;
        this.user_login_id = user_login_id;
        this.user_pw = user_pw;
        this.user_status = user_status;
        this.user_nickname = user_nickname;
        this.user_bio = user_bio;
        this.user_phonenumber = user_phonenumber;
        this.user_photo = user_photo;
        this.age_group = age_group;
        this.createdAt = new Date();
    }

    public UserDto(int user_id, String user_login_id, String user_pw, String user_status,
                   String user_nickname, String user_bio, String user_phonenumber,
                   String user_photo, int age_group, Date createdAt,
                   String auth_provider, String auth_id) {
        this.user_id = user_id;
        this.user_login_id = user_login_id;
        this.user_pw = user_pw;
        this.user_status = user_status;
        this.user_nickname = user_nickname;
        this.user_bio = user_bio;
        this.user_phonenumber = user_phonenumber;
        this.user_photo = user_photo;
        this.age_group = age_group;
        this.createdAt = createdAt;
        this.auth_provider = auth_provider;
        this.auth_id = auth_id;
    }

    // ===== Getter / Setter =====
    public int getUser_id() { return user_id; }
    public void setUser_id(int user_id) { this.user_id = user_id; }

    public String getUser_login_id() { return user_login_id; }
    public void setUser_login_id(String user_login_id) { this.user_login_id = user_login_id; }

    public String getUser_pw() { return user_pw; }
    public void setUser_pw(String user_pw) { this.user_pw = user_pw; }

    public String getUser_status() { return user_status; }
    public void setUser_status(String user_status) { this.user_status = user_status; }

    public String getUser_nickname() { return user_nickname; }
    public void setUser_nickname(String user_nickname) { this.user_nickname = user_nickname; }

    public String getUser_bio() { return user_bio; }
    public void setUser_bio(String user_bio) { this.user_bio = user_bio; }

    public String getUser_phonenumber() { return user_phonenumber; }
    public void setUser_phonenumber(String user_phonenumber) { this.user_phonenumber = user_phonenumber; }

    public String getUser_photo() { return user_photo; }
    public void setUser_photo(String user_photo) { this.user_photo = user_photo; }

    public int getAge_group() { return age_group; }
    public void setAge_group(int age_group) { this.age_group = age_group; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getAuth_provider() { return auth_provider; }
    public void setAuth_provider(String auth_provider) { this.auth_provider = auth_provider; }

    public String getAuth_id() { return auth_id; }
    public void setAuth_id(String auth_id) { this.auth_id = auth_id; }

    // 편의: 소셜 연동 여부
    public boolean isSocialUser() {
        return auth_provider != null && !auth_provider.isBlank()
            && auth_id != null && !auth_id.isBlank();
    }

    @Override
    public String toString() {
        String maskedPw = (user_pw == null || user_pw.isBlank()) ? "null" : "****";
        return "UserDto{" +
                "user_id=" + user_id +
                ", user_login_id='" + user_login_id + '\'' +
                ", user_pw=" + maskedPw +
                ", user_status='" + user_status + '\'' +
                ", user_nickname='" + user_nickname + '\'' +
                ", user_bio='" + user_bio + '\'' +
                ", user_phonenumber='" + user_phonenumber + '\'' +
                ", user_photo='" + user_photo + '\'' +
                ", age_group=" + age_group +
                ", createdAt=" + createdAt +
                ", auth_provider='" + auth_provider + '\'' +
                ", auth_id='" + auth_id + '\'' +
                '}';
    }
}
