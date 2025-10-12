package kr.or.kosa.service.admin;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminMemberDao;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.UserDto;

public class AdminMemberService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            AdminMemberDao dao = new AdminMemberDao();

            //  현재 페이지 파라미터
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }

            int pageSize = 9; // 한 페이지당 회원 수
            int totalCount = dao.getUserCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            int offset = (currentPage - 1) * pageSize;

            // 현재 페이지 데이터 가져오기
            List<UserDto> memberList = dao.getPagedUsers(offset, pageSize);

            //  PageResult 객체 생성 (기존 구조 사용)
            PageResult<UserDto> pageResult = new PageResult<>();
            pageResult.setData(memberList);
            pageResult.setTotalCount(totalCount);
            pageResult.setPageSize(pageSize);
            pageResult.setCurrentPage(currentPage);
            pageResult.setTotalPages(totalPages);

            //  JSP로 전달
            request.setAttribute("memberList", memberList);
            request.setAttribute("pageResult", pageResult);

            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/admin/adminMember.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return forward;
    }
}
