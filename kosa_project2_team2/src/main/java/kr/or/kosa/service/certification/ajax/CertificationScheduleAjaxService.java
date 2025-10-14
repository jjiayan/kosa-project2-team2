package kr.or.kosa.service.certification.ajax;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

public class CertificationScheduleAjaxService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        // 1. API 호출 ( /certifications/schedule )
        // 2. JSON → List<CertificationScheduleDto>
        // 3. DAO 호출 → INSERT or MERGE
        // 4. 결과 setAttribute

        System.out.println("[CertificationScheduleSyncService] 시험 일정 동기화 시작");

        request.setAttribute("message", "SCHEDULE 동기화 완료!");

        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/views/certification/syncResult.jsp");
        return forward;
    }
}
