package kr.or.kosa.service.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

/**
 * - 웹 요청(/certificationSync.cert)을 처리하는 Action 클래스
 * - 내부에서 CertificationSyncService (비즈니스 로직)를 호출
 */
public class CertificationSyncActionService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();
        
        try {
            // 비즈니스 로직 호출 (API → DB 동기화 수행)
            CertificationSyncService syncService = new CertificationSyncService();
            int result = syncService.syncFromApi();

            // 동기화 결과를 사용자에게 메시지로 전달
            request.setAttribute("board_msg", "자격증 데이터 동기화 완료 (" + result + "건 반영)");
            request.setAttribute("board_url", "certificationList.cert");

            // redirect.jsp로 forward
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/redirect.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            // 예외 발생 시 에러 페이지로 이동
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }
}
