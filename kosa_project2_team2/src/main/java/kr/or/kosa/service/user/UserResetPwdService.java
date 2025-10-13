package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;
import kr.or.kosa.utils.SHA256;

public class UserResetPwdService implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward f = new ActionForward();
        try {
            HttpSession session = request.getSession(false);
            String loginId = (session == null) ? null : (String) session.getAttribute("PWD_RESET_LOGIN_ID");

            if (loginId == null) {
                request.setAttribute("errorMsg", "인증 세션이 만료되었습니다. 다시 시도해 주세요.");
                f.setRedirect(false);
                f.setPath("/WEB-INF/views/user/findPwd.jsp");
                return f;
            }

            String pw1 = request.getParameter("newPw");
            String pw2 = request.getParameter("confirmPw");

            if (pw1 == null || pw1.isBlank()) {
                request.setAttribute("pwError", "새 비밀번호를 입력해 주세요.");
                request.setAttribute("verified", true); // 재설정 폼 계속 표시
            } else if (pw1.length() < 8) {
                request.setAttribute("pwError", "비밀번호는 8자 이상이어야 합니다.");
                request.setAttribute("verified", true);
            } else if (!pw1.equals(pw2)) {
                request.setAttribute("pwError", "비밀번호가 서로 다릅니다.");
                request.setAttribute("verified", true);
            } else {
                // 저장
                String enc = SHA256.encodeSha256(pw1); // 현재 프로젝트 해시 정책 그대로 사용
                UserDao dao = new UserDao();
                int updated = dao.updatePasswordByLoginId(loginId, enc);
                if (updated > 0) {
                    session.removeAttribute("PWD_RESET_LOGIN_ID");
                    request.setAttribute("resetSuccess", true);
                } else {
                    request.setAttribute("errorMsg", "비밀번호 변경 중 오류가 발생했습니다.");
                    request.setAttribute("verified", true);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "처리 중 오류가 발생했습니다.");
        }

        f.setRedirect(false);
        f.setPath("/WEB-INF/views/user/findPwd.jsp");
        return f;
    }
}
