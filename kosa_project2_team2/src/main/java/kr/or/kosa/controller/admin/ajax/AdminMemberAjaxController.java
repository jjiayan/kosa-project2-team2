package kr.or.kosa.controller.admin.ajax;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.UserDto;

@WebServlet("/AdminMemberAjax")
public class AdminMemberAjaxController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminMemberAjaxController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        try {
        	 //  페이지 번호
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }

            //  닉네임 검색 파라미터
            String nickname = request.getParameter("nickname");
            if (nickname == null) nickname = "";
            nickname = nickname.trim();

            //  페이징 기본 세팅
            int pageSize = 9;
            int offset = (page - 1) * pageSize;

            AdminDao dao = new AdminDao();

            int totalCount;
            List<UserDto> memberList;

            //  닉네임이 비어있을 경우 전체 회원 조회, 아니면 검색 조회 - 오버로딩
            if (nickname.isEmpty()) {
                totalCount = dao.getUserCount(""); // 전체 count
                memberList = dao.getPagedUsers(offset, pageSize, ""); // 전체 목록
            } else {
                totalCount = dao.getUserCount(nickname); // 검색 count
                memberList = dao.getPagedUsers(offset, pageSize, nickname); // 검색 목록
            }

            //  페이지 수 계산
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            //  PageResult 객체 구성
            PageResult<UserDto> pageResult = new PageResult<>();
            pageResult.setData(memberList);
            pageResult.setTotalCount(totalCount);
            pageResult.setCurrentPage(page);
            pageResult.setTotalPages(totalPages);
            pageResult.setPageSize(pageSize);

            //  JSON 응답
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
