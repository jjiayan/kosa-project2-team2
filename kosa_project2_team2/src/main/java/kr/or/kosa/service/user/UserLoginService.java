package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;
import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.SHA256;

public class UserLoginService implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward f = new ActionForward();
        try {
            String loginId = request.getParameter("userId");
            String pw      = request.getParameter("userPw");

            // 기본 검증
            if (loginId == null || loginId.isBlank() || pw == null || pw.isBlank()) {
                request.setAttribute("errorMsg", "아이디와 비밀번호를 모두 입력해 주세요.");
                f.setRedirect(false);
                f.setPath("/WEB-INF/views/user/login.jsp");
                return f;
            }

            String enc = SHA256.encodeSha256(pw);

            UserDao dao = new UserDao();
            UserDto user = dao.findByLoginId(loginId.trim());

            if (user == null) {
                request.setAttribute("errorMsg", "존재하지 않는 아이디입니다.");
                f.setRedirect(false);
                f.setPath("/WEB-INF/views/user/login.jsp");
                return f;
            }

            // 상태 체크: ADMIN은 예외 처리 (관리자 계정은 상태와 무관하게 로그인 허용)
            String status = user.getUser_status();
            String id = user.getUser_login_id();

            if (!"ADMIN".equalsIgnoreCase(id) && status != null && !"ACTIVE".equalsIgnoreCase(status)) {
                request.setAttribute("errorMsg", "비활성화된 계정입니다.");
                f.setRedirect(false);
                f.setPath("/WEB-INF/views/user/login.jsp");
                return f;
            }

            // 비밀번호 검사
            if (!enc.equals(user.getUser_pw())) {
                request.setAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
                f.setRedirect(false);
                f.setPath("/WEB-INF/views/user/login.jsp");
                return f;
            }

            // --- 안전 조치: 비밀번호(해시) 제거 및 세션 재생성 ---
            user.setUser_pw(null); // 절대 세션에 비밀번호를 남기지 않음

            // 기존 세션 무효화(세션 고정 공격 방지) — 안전하게 새 세션 생성
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                try {
                    oldSession.invalidate();
                } catch (IllegalStateException ignore) {
                    // 이미 invalidated 됐으면 무시
                }
            }
            //1 
            //2
            
            //  1, 2 , 3 4
            
            HttpSession session = request.getSession(true);
            session.setAttribute("LOGIN_USER", user);

            // 메인으로 이동
            f.setRedirect(true);
            f.setPath("/roomlist.room?userId="+user.getUser_id());
            return f;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "로그인 처리 중 오류가 발생했습니다.");
            f.setRedirect(false);
            f.setPath("/WEB-INF/views/user/login.jsp");
            return f;
        }
    }
}
