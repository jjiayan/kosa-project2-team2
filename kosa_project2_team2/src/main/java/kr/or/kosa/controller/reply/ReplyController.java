package kr.or.kosa.controller.reply;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.user.UserSignupService;

//  
@WebServlet("*.do")
public class ReplyController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String USER_VIEW_PATH = "/WEB-INF/views/reply/";

    public ReplyController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String command = uri.substring(ctx.length());

        System.out.println("요청 경로: " + command);

        Action action = null;
        ActionForward forward = null;

        if (command.equals("/tmp.do")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "tmp.jsp");
        } else if (command.equals("/tmp.do")) {
            forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath(USER_VIEW_PATH + "tmp.jsp");
        } else if (command.equals("/tmp.do")) {
            forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath(USER_VIEW_PATH + "tmp.jsp");
        } else if (command.equals("/tmp.do")) {
            forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath(USER_VIEW_PATH + "tmp.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (forward != null) {
            if (forward.isRedirect()) {
                response.sendRedirect(request.getContextPath() + forward.getPath());
            } else {
                request.getRequestDispatcher(forward.getPath()).forward(request, response);
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doProcess(request, response);
    }
}