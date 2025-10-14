package kr.or.kosa.service.admin;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.AdminNoticeDto;

public class AdminNoticeService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();

        try {
            int page = 1;
            int pageSize = 5; // 한 페이지에 표시할 게시글 수
            String pageParam = request.getParameter("page");

            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
            }

            int offset = (page - 1) * pageSize;

            AdminDao dao = new AdminDao();
            List<AdminNoticeDto> noticeList = dao.getPagedNotices(offset, pageSize);
            int totalCount = dao.getNoticeCount();
            int totalPage = (int) Math.ceil((double) totalCount / pageSize);

            // JSP로 전달
            request.setAttribute("noticeList", noticeList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPage", totalPage);

            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/admin/adminNotice.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return forward;
    }
}
