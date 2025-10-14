package kr.or.kosa.service.admin;

import java.io.PrintWriter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.UserDto;

public class AdminNoticeWriteService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = null; 
        response.setContentType("application/json; charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            request.setCharacterEncoding("UTF-8");
            HttpSession session = request.getSession(false);
            UserDto loginUser = (session != null) ? (UserDto) session.getAttribute("LOGIN_USER") : null;

 
            if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getUser_status())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"success\": false, \"message\": \"관리자만 공지사항을 작성할 수 있습니다.\"}");
                return null;
            }

            String title = request.getParameter("title");
            String content = request.getParameter("content");

            if (title == null || title.isBlank() || content == null || content.isBlank()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"제목과 내용을 모두 입력해주세요.\"}");
                return null;
            }

            AdminDao dao = new AdminDao();
            int result = dao.insertNotice(title, content, loginUser.getUser_id());

            if (result > 0) {
                out.print("{\"success\": true, \"message\": \"공지사항 등록 성공\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"공지사항 등록 실패\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
            } catch (Exception ignored) {}
        }

        return forward;  
    }
}
