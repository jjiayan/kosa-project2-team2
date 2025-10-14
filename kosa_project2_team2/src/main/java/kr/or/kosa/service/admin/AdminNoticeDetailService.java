package kr.or.kosa.service.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.AdminNoticeDto;

public class AdminNoticeDetailService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();

        try {
            int noticeId = Integer.parseInt(request.getParameter("noticeId"));
            HttpSession session = request.getSession();
            
            AdminDao dao = new AdminDao();
            
            String viewKey = "viewed_notice_" + noticeId;
            Boolean viewed = (Boolean) session.getAttribute(viewKey);
            
            // 세션에 기록이 없을 때만 조회수 증가
            if (viewed == null || !viewed) {
                dao.updateNoticeViewCnt(noticeId);
                session.setAttribute(viewKey, true);
            }
            
           
            // 공지사항 데이터 조회
            AdminNoticeDto notice = dao.getNoticeById(noticeId);

            if (notice != null) {
                request.setAttribute("notice", notice);
                forward.setPath("/WEB-INF/views/admin/adminNoticeDetail.jsp");
            } else {
                request.setAttribute("message", "해당 공지사항이 존재하지 않습니다.");
                forward.setPath("/WEB-INF/views/common/error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "공지사항 상세보기 중 오류가 발생했습니다.");
            forward.setPath("/WEB-INF/views/common/error.jsp");
        }

        forward.setRedirect(false);
        return forward;
    }
}
