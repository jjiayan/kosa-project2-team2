package kr.or.kosa.service.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;
import kr.or.kosa.dto.AdminNoticeDto;

public class AdminNoticeUpdateService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();

        try {
            request.setCharacterEncoding("UTF-8");
            AdminDao dao = new AdminDao();
 
            String noticeIdParam = request.getParameter("noticeId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            // noticeId만 있는 경우 → 기존 내용 불러오기
            if (title == null && content == null) {
                int noticeId = Integer.parseInt(noticeIdParam);
                AdminNoticeDto notice = dao.getNoticeById(noticeId);
                request.setAttribute("notice", notice);
                forward.setRedirect(false);
                forward.setPath("/WEB-INF/views/admin/adminNoticeForm.jsp");
                return forward;
            }

            // 실제 수정 요청 (title, content 모두 있을 경우)
            int noticeId = Integer.parseInt(noticeIdParam);
            int result = dao.updateNotice(noticeId, title, content);

            if (result > 0) {
                System.out.println("✅ 공지사항 수정 성공: " + noticeId);
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/adminNoticeDetail.admin?noticeId=" + noticeId);
            } else {
                request.setAttribute("message", "공지사항 수정에 실패했습니다.");
                forward.setRedirect(false);
                forward.setPath("/WEB-INF/views/common/error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "공지사항 수정 중 오류가 발생했습니다.");
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/common/error.jsp");
        }

        return forward;
    }
}
