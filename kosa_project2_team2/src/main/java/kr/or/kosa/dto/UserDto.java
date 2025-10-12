package kr.or.kosa.dto;

public class UserDto {
    private int user_id;                  // 사용자 고유 번호 (PK)
    private String user_login_id;         // 사용자 로그인 아이디
    private String user_pw;               // 사용자 비밀번호
    private String user_status;           // 사용자 상태 (예: 활성, 비활성, 탈퇴 등)
    private String user_nickname;         // 사용자 닉네임
    private String user_bio;              // 사용자 자기소개
    private String user_phonenumber;      // 사용자 휴대폰번호 (char(11))
    private String user_photo;            // 사용자 사진 (파일 경로 또는 URL)

    // 기본 생성자
    public UserDto() {}

    // 전체 필드 생성자
    public UserDto(int user_id, String user_login_id, String user_pw, String user_status,
                   String user_nickname, String user_bio, String user_phonenumber, String user_photo) {
        this.user_id = user_id;
        this.user_login_id = user_login_id;
        this.user_pw = user_pw;
        this.user_status = user_status;
        this.user_nickname = user_nickname;
        this.user_bio = user_bio;
        this.user_phonenumber = user_phonenumber;
        this.user_photo = user_photo;
    }

    // Getter & Setter
    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUser_login_id() {
        return user_login_id;
    }

    public void setUser_login_id(String user_login_id) {
        this.user_login_id = user_login_id;
    }

    public String getUser_pw() {
        return user_pw;
    }

    public void setUser_pw(String user_pw) {
        this.user_pw = user_pw;
    }

    public String getUser_status() {
        return user_status;
    }

    public void setUser_status(String user_status) {
        this.user_status = user_status;
    }

    public String getUser_nickname() {
        return user_nickname;
    }

    public void setUser_nickname(String user_nickname) {
        this.user_nickname = user_nickname;
    }

    public String getUser_bio() {
        return user_bio;
    }

    public void setUser_bio(String user_bio) {
        this.user_bio = user_bio;
    }

    public String getUser_phonenumber() {
        return user_phonenumber;
    }

    public void setUser_phonenumber(String user_phonenumber) {
        this.user_phonenumber = user_phonenumber;
    }

    public String getUser_photo() {
        return user_photo;
    }

    public void setUser_photo(String user_photo) {
        this.user_photo = user_photo;
    }

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
                '}';
    }
}
