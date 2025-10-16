package kr.or.kosa.dto;

import java.util.Date;

public class UserDto {
    private int user_id;
    private String user_login_id;
    private String user_pw;
    private String user_status;
    private String user_nickname;
    private String user_bio;
    private String user_phonenumber;
    private String user_photo;
    private int age_group;          // ✅ 숫자형 나이대 (10,20,30,40,50)
    private Date createdAt;

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
                   String user_photo, int age_group, Date createdAt) {
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

    @Override
    public String toString() {
        return "UserDto{" +
                "user_id=" + user_id +
                ", user_login_id='" + user_login_id + '\'' +
                ", user_pw='" + user_pw + '\'' +
                ", user_status='" + user_status + '\'' +
                ", user_nickname='" + user_nickname + '\'' +
                ", user_bio='" + user_bio + '\'' +
                ", user_phonenumber='" + user_phonenumber + '\'' +
                ", user_photo='" + user_photo + '\'' +
                ", age_group=" + age_group +
                ", createdAt=" + createdAt +
                '}';
    }
}
