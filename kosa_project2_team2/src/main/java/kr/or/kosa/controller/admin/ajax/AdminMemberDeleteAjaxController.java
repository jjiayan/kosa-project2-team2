package kr.or.kosa.controller.admin.ajax;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.UserDto;

@WebServlet("/AdminMemberDeleteAjax")
public class AdminMemberDeleteAjaxController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminMemberDeleteAjaxController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {
            // 세션에서 로그인 정보 가져오기
            HttpSession session = request.getSession(false);
            UserDto loginUser = (session != null)
                    ? (UserDto) session.getAttribute("LOGIN_USER")
                    : null;

            // 로그인 여부 및 관리자 권한 확인
            if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getUser_status())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
                response.getWriter().write("{\"error\": \"관리자만 접근할 수 있습니다.\"}");
                return;
            }

            // 파라미터 검증
            String userIdParam = request.getParameter("user_id");
            if (userIdParam == null || userIdParam.isBlank()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"user_id가 누락되었습니다.\"}");
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            // 탈퇴 수행 (DAO 호출)
            AdminDao dao = new AdminDao();
            int result = dao.deleteUser(userId);

            // 결과 응답
            if (result > 0) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"삭제 실패\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"user_id 형식이 잘못되었습니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }
}
