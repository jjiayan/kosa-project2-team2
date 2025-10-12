package kr.or.kosa.controller.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

public class CertificationListController implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);   // forward 방식
        forward.setPath("/WEB-INF/views/certification/certification_list.jsp");
        return forward;
    }
}
