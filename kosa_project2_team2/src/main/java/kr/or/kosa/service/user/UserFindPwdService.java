package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;

public class UserFindPwdService implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward f = new ActionForward();
        try {
        	// UserFindPwdService
        	System.out.println("[FindPwd] raw phone=" + request.getParameter("phone") + ", raw userId=" + request.getParameter("userId"));
        	String phone = request.getParameter("phone");
        	String userId = request.getParameter("userId");
        	if (userId != null) userId = userId.trim();
        	if (phone  != null) phone  = phone.replaceAll("[^0-9]","").trim();
        	System.out.println("[FindPwd] normalized userId=" + userId + ", phone=" + phone);

            boolean hasError = false;

            if (phone == null || phone.isBlank()) {
                request.setAttribute("phoneError", "휴대폰번호를 입력해 주세요.");
                hasError = true;
            } else {
                phone = phone.replaceAll("[^0-9]", "");
                if (phone.length() < 10) {
                    request.setAttribute("phoneError", "휴대폰번호 형식이 올바르지 않습니다.");
                    hasError = true;
                }
            }

            if (userId == null || userId.isBlank()) {
                request.setAttribute("idError", "아이디를 입력해 주세요.");
                hasError = true;
            }

            if (!hasError) {
                UserDao dao = new UserDao();
                boolean ok = dao.existsByLoginIdAndPhone(userId, phone);
                if (ok) {
                    request.setAttribute("verified", true); // JSP에서 재설정 폼 렌더
                    HttpSession session = request.getSession();
                    session.setAttribute("PWD_RESET_LOGIN_ID", userId); // ★ 세션에 안전하게 보관
                } else {
                    request.setAttribute("errorMsg", "입력하신 정보가 일치하지 않습니다.");
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
