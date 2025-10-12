package kr.or.kosa.controller.certification;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

import java.io.IOException;

@WebServlet("*.cert")
public class FrontCertificationController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 요청 URI 및 ContextPath 분리
        String requestUri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand = requestUri.substring(contextPath.length());

        System.out.println("urlCommand = " + urlCommand);

        Action action = null;
        ActionForward forward = null;

        if (urlCommand.equals("/certificationList.cert")) {
            action = new CertificationListController();

        } else if (urlCommand.equals("/certificationDetail.cert")) {
            action = new CertificationDetailController();

        } else if (urlCommand.equals("/certificationAjax.cert")) {
            action = new CertificationAjaxController();

        } else if (urlCommand.equals("/certificationSync.cert")) {
            action = new CertificationSyncController();

        } else {
            // 404 or 에러 페이지
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        // Action 실행
        if (action != null) {
            forward = action.execute(request, response);
        }

        // forward or redirect
        if (forward != null) {
            if (forward.isRedirect()) {
                response.sendRedirect(forward.getPath());
            } else {
                RequestDispatcher dis = request.getRequestDispatcher(forward.getPath());
                dis.forward(request, response);
            }
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
