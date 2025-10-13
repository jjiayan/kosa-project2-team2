package kr.or.kosa.service.certification.sync;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

public class CertificationStatsSyncService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        // 1. API 호출 ( /certifications/stats )
        // 2. JSON → List<CertificationStatsDto>
        // 3. DAO 호출 → INSERT or MERGE
        // 4. 결과 setAttribute

        System.out.println("[CertificationStatsSyncService] 시험 통계 동기화 시작");

        request.setAttribute("message", "STATS 동기화 완료!");

        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/views/certification/syncResult.jsp");
        return forward;
    }
}
