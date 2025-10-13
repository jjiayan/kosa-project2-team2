package kr.or.kosa.service.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminMemberDao;

public class AdminMemberDeleteService implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            AdminMemberDao dao = new AdminMemberDao();
            int result = dao.deleteUser(userId);

            if (result > 0) {
                System.out.println("✅ 회원 탈퇴 성공 (user_id=" + userId + ")");
            } else {
                System.out.println("❌ 회원 탈퇴 실패 (user_id=" + userId + ")");
            }

            // 탈퇴 후 회원 목록 페이지로 이동
            forward.setRedirect(true);
            forward.setPath(request.getContextPath() + "/adminMember.admin");

        } catch (Exception e) {
            e.printStackTrace();
            forward.setRedirect(true);
            forward.setPath(request.getContextPath() + "/adminMember.admin");
        }

        return forward;
    }
}
