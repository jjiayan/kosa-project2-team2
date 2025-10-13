package kr.or.kosa.controller.admin.ajax;

import com.google.gson.Gson;
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

@WebServlet("/AdminMemberAjax")
public class AdminMemberAjaxController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminMemberAjaxController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }

            int pageSize = 9;
            AdminMemberDao dao = new AdminMemberDao();

            // 전체 회원 수 (탈퇴된 회원 제외)
            int totalCount = dao.getUserCount();  
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            if (totalPages == 0) totalPages = 1;   
 
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            int offset = (page - 1) * pageSize;

            List<UserDto> memberList = dao.getPagedUsers(offset, pageSize);

            // PageResult 객체 구성
            PageResult<UserDto> pageResult = new PageResult<>();
            pageResult.setData(memberList);
            pageResult.setTotalCount(totalCount);
            pageResult.setCurrentPage(page);
            pageResult.setTotalPages(totalPages);
            pageResult.setPageSize(pageSize);

            response.getWriter().write(new Gson().toJson(pageResult));

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
