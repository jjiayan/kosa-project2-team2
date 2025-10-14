package kr.or.kosa.service.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

public class AdminNoticeInsertService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();

        try {
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/admin/adminNoticeForm.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return forward;
    }
}
