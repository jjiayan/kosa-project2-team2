package kr.or.kosa.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.user.UserEditOkService;
import kr.or.kosa.service.user.UserFindIdService;
import kr.or.kosa.service.user.UserFindPwdService;
import kr.or.kosa.service.user.UserLoginService;
import kr.or.kosa.service.user.UserResetPwdService;
import kr.or.kosa.service.user.UserSignupService;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.io.IOException;
import java.sql.Connection;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 20
)
@WebServlet("*.user")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String USER_VIEW_PATH = "/WEB-INF/views/user/";

    public UserController() {
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

        if (command.equals("/login.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "main.jsp");
        }else if (command.equals("/logout.user")) {
            request.getSession().invalidate();
            forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath("/index.user");
        }
        else if (command.equals("/loginOk.user")) {  
            action = new UserLoginService();
            forward = action.execute(request, response);
        }
        else if (command.equals("/index.user")) {
            forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath("/index.jsp");
        } else if (command.equals("/findId.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "findId.jsp");
        }else if (command.equals("/findIdOk.user")) {
            action = new UserFindIdService();
            forward = action.execute(request, response);
        }
        else if (command.equals("/findPwd.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "findPwd.jsp");
        }else if (command.equals("/findPwdOk.user")) { // ★ 추가
            action = new UserFindPwdService();
            forward = action.execute(request, response);
        }else if (command.equals("/resetPwdOk.user")) {                  
            action = new UserResetPwdService();
            forward = action.execute(request, response);
        }
        else if (command.equals("/signup.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "signup.jsp");
        } else if (command.equals("/signupOk.user")) {
            action = new UserSignupService();
            forward = action.execute(request, response);
        }
        else if (command.equals("/photoTest.user")) {
            action = new kr.or.kosa.service.user.UserPhotoTestService();
            forward = action.execute(request, response);
        }else if (command.equals("/mypage/edit.user")) {              
        	forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "mypageEdit.jsp");
        }else if (command.equals("/mypage/editOk.user")) {
            action = new UserEditOkService();
            forward = action.execute(request, response);
        }else if (command.equals("/mypage/info.user")) {              
        	forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "mypageInfo.jsp");
        }else if (command.equals("/mypage/myroomspage.user")) {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath(USER_VIEW_PATH + "mypageRooms.jsp");
        }
        
        
        else {
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