package kr.or.kosa.service.admin;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.UserDto;

public class AdminMemberService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
        	AdminDao dao = new AdminDao();

            // 현재 페이지 파라미터
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }

            // 한 페이지당 회원 수
            int pageSize = 9; 
            int totalCount = dao.getUserCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            int offset = (currentPage - 1) * pageSize;

            // 페이지 블록 (한 번에 5개 번호씩 표시)
            int pageBlock = 5;
            int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
            int endPage = startPage + pageBlock - 1;
            if (endPage > totalPages) endPage = totalPages;

            // 회원 목록 불러오기
            List<UserDto> memberList = dao.getPagedUsers(offset, pageSize);

            // 결과 객체 세팅
            PageResult<UserDto> pageResult = new PageResult<>();
            pageResult.setData(memberList);
            pageResult.setTotalCount(totalCount);
            pageResult.setPageSize(pageSize);
            pageResult.setCurrentPage(currentPage);
            pageResult.setTotalPages(totalPages);

            // JSP로 전달
            request.setAttribute("memberList", memberList);
            request.setAttribute("pageResult", pageResult);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);

            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/admin/adminMember.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return forward;
    }
}
