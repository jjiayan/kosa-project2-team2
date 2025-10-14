package kr.or.kosa.service.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.UserDto;

public class AdminNoticeWriteService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();

        try {
            request.setCharacterEncoding("UTF-8");

            String title = request.getParameter("title");
            String content = request.getParameter("content");

            // 세션에서 로그인 사용자 정보 가져오기
            UserDto loginUser = (UserDto) request.getSession().getAttribute("LOGIN_USER");
            if (loginUser == null) {
                // 로그인 안 된 경우 로그인 페이지로 이동
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/login.user");
                return forward;
            }

            int userId = loginUser.getUser_id();

            AdminDao dao = new AdminDao();
            int result = dao.insertNotice(title, content, userId);

            if (result > 0) {
                System.out.println("✅ 공지사항 등록 성공: " + title);
                // 등록 성공 → 목록으로 리다이렉트
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/adminNotice.admin");
            } else {
                System.out.println("❌ 공지사항 등록 실패");
                // 실패 → 다시 작성 페이지로 리다이렉트
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/adminNoticInsert.admin");
            }

        } catch (Exception e) {
            e.printStackTrace();
            forward.setRedirect(true);
            forward.setPath(request.getContextPath() + "/adminNoticInsert.admin");
        }

        return forward;
    }
}
