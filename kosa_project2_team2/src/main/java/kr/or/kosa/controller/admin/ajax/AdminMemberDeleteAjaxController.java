package kr.or.kosa.controller.admin.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.AdminMemberDao;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.UserDto;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
 
@WebServlet("/AdminMemberDeleteAjax")
public class AdminMemberDeleteAjaxController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public AdminMemberDeleteAjaxController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        try {
            int userId = Integer.parseInt(request.getParameter("user_id"));
            AdminMemberDao dao = new AdminMemberDao();
            int result = dao.deleteUser(userId);

            if (result > 0) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
