package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        ActionForward forward = new ActionForward(); // 항상 생성해두기
        forward.setRedirect(false);

        try {
            // 1) 업로드 파일(아바타)
            String photoUrl = null;
            try {
                Part avatar = request.getPart("avatarFile");
                if (avatar != null && avatar.getSize() > 0) {
                    photoUrl = FileUploadUtil.saveImageToUpload(avatar, request.getServletContext());
                }
            } catch (Exception ignore) {
                // multipart 설정 미적용 등으로 여기서 예외 날 수 있음 → 무시
            }

            // 2) 파라미터 수집
            String loginId  = nvl(request.getParameter("userId"));
            String pw       = nvl(request.getParameter("password"));
            String nickname = nvl(request.getParameter("nickname"));
            String bio      = nvl(request.getParameter("bio"));
            String phoneRaw = request.getParameter("phone");
            String phone    = phoneRaw == null ? "" : phoneRaw.replaceAll("[^0-9]", ""); // 숫자만 11자리 기대
            String ageParam = nvl(request.getParameter("ageGroup")); // "10","20","30","40","50" 로 들어와야 함

            // 3) 서버측 기본 검증
            if (loginId.isEmpty() || pw.isEmpty() || nickname.isEmpty() || phone.isEmpty() || ageParam.isEmpty()) {
                request.setAttribute("board_msg", "필수 항목이 비었습니다. 다시 시도해 주세요.");
                request.setAttribute("board_url", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }

            int ageGroup;
            try {
                ageGroup = Integer.parseInt(ageParam);
            } catch (NumberFormatException e) {
                request.setAttribute("board_msg", "나이대 값이 올바르지 않습니다.");
                request.setAttribute("board_url", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }

            // 허용값 체크 (10,20,30,40,50)
            if (!(ageGroup == 10 || ageGroup == 20 || ageGroup == 30 || ageGroup == 40 || ageGroup == 50)) {
                request.setAttribute("board_msg", "나이대는 10, 20, 30, 40, 50만 선택 가능합니다.");
                request.setAttribute("board_url", "signup.user");
                forward.setPath("/redirect.jsp");
                return forward;
            }

            // 4) 비밀번호 해시
            String encPw = SHA256.encodeSha256(pw);

            // 5) DTO 구성
            UserDto user = new UserDto();
            user.setUser_login_id(loginId);
            user.setUser_pw(encPw);
            user.setUser_status("ACTIVE");
            user.setUser_nickname(nickname);
            user.setUser_bio(bio);
            user.setUser_phonenumber(phone);
            user.setUser_photo(photoUrl);  // null이면 DB에서 기본 처리/프론트 기본이미지 사용
            user.setAge_group(ageGroup);   // ✅ int로 저장 (10/20/30/40/50)

            // 6) 저장
            UserDao dao = new UserDao();
            int result = dao.insertUser(user);

            String msg = (result > 0) ? "회원가입 성공" : "회원가입 실패";
            String url = "login.user";

            request.setAttribute("board_msg", msg);
            request.setAttribute("board_url", url);
            forward.setPath("/redirect.jsp");
            return forward;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("board_msg", "서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
            request.setAttribute("board_url", "signup.user");
            forward.setPath("/redirect.jsp");
            return forward;
        }
    }

    private String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }
}
