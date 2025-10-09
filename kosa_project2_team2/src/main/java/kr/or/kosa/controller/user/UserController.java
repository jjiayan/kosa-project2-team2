package kr.or.kosa.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.io.IOException;
import java.sql.Connection;


@WebServlet("*.user")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public UserController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String command = uri.substring(ctx.length());

        System.out.println("📩 요청 경로: " + command);

        ActionForward forward = null;

        // DB 연결 테스트 (선택)
        try (Connection conn = ConnectionPoolHelper.getConnection()) {
            if (conn != null) {
                System.out.println("✅ DB 연결 성공: " + conn);
            } else {
                System.out.println("❌ DB 연결 실패: conn is null");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ======================================
        // 요청별 분기
        // ======================================

        if (command.equals("/login.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/user/login.jsp");
        }
        else if (command.equals("/index.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/index.jsp"); // webapp 바로 아래 경로
        }
        else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // ======================================
        // View 이동
        // ======================================
        if (forward != null) {
            if (forward.isRedirect()) {
                response.sendRedirect(forward.getPath());
            } else {
                request.getRequestDispatcher(forward.getPath()).forward(request, response);
            }
        }
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

}
