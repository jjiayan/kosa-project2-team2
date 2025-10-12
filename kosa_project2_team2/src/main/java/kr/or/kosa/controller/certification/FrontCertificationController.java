package kr.or.kosa.controller.certification;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.controller.certification.ajax.CertificationAjaxController;

@WebServlet("*.cert")
public class FrontCertificationController extends HttpServlet {
	private static final long serialVersionUID = 1L;

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

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestUri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand = requestUri.substring(contextPath.length());

        System.out.println("urlCommand = " + urlCommand);

        Action action = null;
        ActionForward forward = null;

        if(urlCommand.equals("/certificationList.cert")) {
            action = new CertificationAjaxController();    // 화면 또는 DB처리 포함
            forward = action.execute(request, response);

        } else if(urlCommand.equals("/certificationAjax.cert")) {
            action = new CertificationAjaxController();     // JSON 응답
            forward = action.execute(request, response);
        }

        if(forward != null) {
            if(forward.isRedirect()) {
                response.sendRedirect(forward.getPath());
            } else {
                request.getRequestDispatcher(forward.getPath()).forward(request, response);
            }
        }
    }
}
