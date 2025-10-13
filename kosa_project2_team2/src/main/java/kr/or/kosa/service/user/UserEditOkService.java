package kr.or.kosa.service.user;

import jakarta.servlet.ServletContext;
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

import java.util.regex.Pattern;

public class UserEditOkService implements Action {

    // 서버측 비밀번호 규칙
    private static final Pattern PW_RULE =
            Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,16}$");

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward f = new ActionForward();
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("LOGIN_USER") == null) {
                f.setRedirect(true);
                f.setPath("/login.user");
                return f;
            }

            UserDto loginUser = (UserDto) session.getAttribute("LOGIN_USER");
            int userId = loginUser.getUser_id();

            String nickname = trim(request.getParameter("nickname"));
            String phone    = trim(request.getParameter("phone"));
            String bio      = trim(request.getParameter("bio"));
            String newPw    = trim(request.getParameter("newPassword"));

            String phoneDigits = (phone == null) ? null : phone.replaceAll("\\D", "");

            // 사진: reset 여부 + 업로드 파일 확인
            String resetPhotoParam = request.getParameter("resetPhoto"); // "1"이면 리셋
            boolean resetPhoto = "1".equals(resetPhotoParam);

            ServletContext ctx = request.getServletContext();
            Part imgPart = null;
            try { imgPart = request.getPart("profileImage"); } catch (Exception ignore) {}

            boolean hasNewUpload = (imgPart != null && imgPart.getSize() > 0 &&
                    imgPart.getContentType() != null &&
                    imgPart.getContentType().startsWith("image/"));
            String photoUrl = null;
            if (hasNewUpload) {
                photoUrl = FileUploadUtil.saveImageToUpload(imgPart, ctx); // 실패 시 null 반환 가능
            }

            // DAO 호출용 플래그
            // setPhoto == null  : 사진 컬럼 미변경
            // setPhoto == true  : photoUrl==null → NULL 저장(초기화), 값 있으면 URL 저장
            Boolean setPhoto = null;
            if (resetPhoto) {
                setPhoto = true;
                photoUrl = null;
            } else if (hasNewUpload) {
                setPhoto = true;  // photoUrl 이 null이면 NULL 저장됨
            }

            UserDao dao = new UserDao();

            // 프로필 업데이트
            dao.updateUserProfileById(userId, nickname, bio, phoneDigits, setPhoto, photoUrl);

            // 비밀번호 업데이트 (입력한 경우만 + 규칙검증)
            if (newPw != null && !newPw.isBlank()) {
                if (!PW_RULE.matcher(newPw).matches()) {
                    request.setAttribute("errorMsg", "비밀번호는 8~16자의 영문 대/소문자, 숫자, 특수문자를 모두 포함해야 합니다.");
                    f.setRedirect(false);
                    f.setPath("/WEB-INF/views/user/mypageEdit.jsp");
                    return f;
                }
                String enc = SHA256.encodeSha256(newPw);
                dao.updateUserPasswordById(userId, enc);
            }

            // 세션 최신화 (pw 제거)
            UserDto fresh = dao.findById(userId);
            if (fresh != null) fresh.setUser_pw(null);
            session.setAttribute("LOGIN_USER", fresh);

            f.setRedirect(true);
            f.setPath("/mypage/edit.user");
            return f;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "내정보 저장 중 오류가 발생했습니다.");
            f.setRedirect(false);
            f.setPath("/WEB-INF/views/user/mypageEdit.jsp");
            return f;
        }
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
