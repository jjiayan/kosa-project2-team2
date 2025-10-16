package kr.or.kosa.controller.admin.ajax;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.admin.AdminStatAjaxService;

@WebServlet("/AdminStatAjax")
public class AdminStatAjaxController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminStatAjaxController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        Action action = new AdminStatAjaxService();
        ActionForward forward = action.execute(request, response);

        // 비동기 응답이므로 JSP 포워딩 없음
        if (forward != null) {
            if (forward.isRedirect()) {
                response.sendRedirect(forward.getPath());
            } else {
                request.getRequestDispatcher(forward.getPath()).forward(request, response);
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
