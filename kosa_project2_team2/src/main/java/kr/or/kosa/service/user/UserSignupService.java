package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;
import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.FileUploadUtil;
import kr.or.kosa.utils.SHA256;

public class UserSignupService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);

        try {
            // ✅ 소셜가입 여부 판단 (kakao callback에서 넣어준 hidden)
            String provider = nvl(request.getParameter("provider")); // "kakao" or ""
            String authId   = nvl(request.getParameter("authId"));
            boolean isSocialJoin = (!provider.isEmpty() && !authId.isEmpty());

            // 1) 업로드 파일(아바타)
            String photoUrl = null;
            try {
                Part avatar = request.getPart("avatarFile");
                if (avatar != null && avatar.getSize() > 0) {
                    photoUrl = FileUploadUtil.saveImageToUpload(avatar, request.getServletContext());
                }
            } catch (Exception ignore) { /* multipart 미적용 등은 무시 */ }

            // 2) 파라미터 수집
            String loginId  = nvl(request.getParameter("userId"));
            String pw       = nvl(request.getParameter("password"));
            String nickname = nvl(request.getParameter("nickname"));
            String bio      = nvl(request.getParameter("bio"));
            String phoneRaw = request.getParameter("phone");
            String phone    = phoneRaw == null ? "" : phoneRaw.replaceAll("[^0-9]", "");
            String ageParam = nvl(request.getParameter("ageGroup")); // "10","20","30","40","50"

            // 3) 서버측 기본 검증
            if (loginId.isEmpty() || nickname.isEmpty() || phone.isEmpty() || ageParam.isEmpty()) {
                setMsg(request, "필수 항목이 비었습니다. 다시 시도해 주세요.", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }
            // 일반가입은 비번 필수, 소셜가입은 비번 선택(정책 따라 필수로 바꿔도 OK)
            if (!isSocialJoin && pw.isEmpty()) {
                setMsg(request, "비밀번호를 입력해 주세요.", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }

            int ageGroup;
            try { ageGroup = Integer.parseInt(ageParam); }
            catch (NumberFormatException e) {
                setMsg(request, "나이대 값이 올바르지 않습니다.", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }
            if (!(ageGroup==10 || ageGroup==20 || ageGroup==30 || ageGroup==40 || ageGroup==50)) {
                setMsg(request, "나이대는 10, 20, 30, 40, 50만 선택 가능합니다.", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }

            // 4) 비밀번호 해시 (소셜에서 비번 미입력 가능)
            String encPw = pw.isEmpty() ? null : SHA256.encodeSha256(pw);

            // 5) DTO 구성
            UserDto user = new UserDto();
            user.setUser_login_id(loginId);
            user.setUser_pw(encPw);                // 소셜+미입력이면 null
            user.setUser_status("ACTIVE");
            user.setUser_nickname(nickname);
            user.setUser_bio(bio);
            user.setUser_phonenumber(phone);
            user.setUser_photo(photoUrl);
            user.setAge_group(ageGroup);

            UserDao dao = new UserDao();

            if (isSocialJoin) {
                // 🔐 중복 방지: (provider, authId) 재확인
                UserDto exists = dao.findByAuth(provider, authId);
                if (exists != null) {
                    // 이미 누군가 가입 완료
                    HttpSession s = request.getSession(true);
                    s.setAttribute("LOGIN_USER", exists);
                    s.setAttribute("LOGIN_PROVIDER", provider);
                    forward.setRedirect(true);
                    forward.setPath("/roomlist.room");
                    return forward;
                }

                user.setAuth_provider(provider);
                user.setAuth_id(authId);

                int result = dao.insertSocialUser(user); // auth 포함 INSERT
                if (result > 0) {
                    // 가입 즉시 로그인 (소셜)
                    HttpSession s = request.getSession(true);
                    user.setUser_pw(null); // 세션에 PW 보관 금지
                    s.setAttribute("LOGIN_USER", user);
                    s.setAttribute("LOGIN_PROVIDER", provider);
                    forward.setRedirect(true);
                    forward.setPath("/roomlist.room");
                    return forward;
                } else {
                    setMsg(request, "회원가입 실패", "signup.user");
                    forward.setPath("/redirect.jsp");
                    return forward;
                }

            } else {
                // 일반가입
                int result = dao.insertLocalUser(user);
                String msg = (result > 0) ? "회원가입 성공" : "회원가입 실패";
                String url = (result > 0) ? "login.user" : "signup.user";
                setMsg(request, msg, url);
                forward.setPath("/redirect.jsp");
                return forward;
            }

        } catch (Exception e) {
            e.printStackTrace();
            setMsg(request, "서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.", "signup.user");
            forward.setPath("/redirect.jsp");
            return forward;
        }
    }

    private String nvl(String s) { return (s == null) ? "" : s.trim(); }
    private void setMsg(HttpServletRequest req, String msg, String url){
        req.setAttribute("board_msg", msg);
        req.setAttribute("board_url", url);
    }
}
