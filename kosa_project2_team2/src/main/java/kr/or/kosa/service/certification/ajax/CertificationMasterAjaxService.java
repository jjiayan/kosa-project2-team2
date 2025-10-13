package kr.or.kosa.service.certification.ajax;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

public class CertificationMasterAjaxService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        // 1. API 호출 ( /certifications )
        // 2. JSON → List<CertificationMasterDto>
        // 3. DAO 호출 → INSERT or MERGE
        // 4. 결과를 request.setAttribute 등으로 담기

        System.out.println("[CertificationMasterSyncService] 자격증 기본정보 동기화 시작");

        // 예시: 성공 여부만 세팅
        request.setAttribute("message", "MASTER 동기화 완료!");

        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/views/certification/syncResult.jsp");
        return forward;
    }
}
