package kr.or.kosa.controller.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.certification.CertificationSyncService;

/** [자격증 데이터 동기화 Controller]
 *
 * ✔ 역할
 *  - CertificationSyncService를 호출하여 외부 API 데이터를 DB에 동기화한다.
 *  - 동기화 결과(몇 건 반영됐는지)를 사용자에게 메시지로 보여준다.
 *  - 이후 목록 페이지 등으로 이동시킨다.
 *
 * ✔ 예외 처리
 *  - 실패 시 실패 메시지와 함께 지정된 페이지로 이동
 *
 * ✔ 화면 이동 방식
 *  - redirect.jsp를 활용 (msg + url 전달)
 */
public class CertificationSyncController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            CertificationSyncService service = new CertificationSyncService();
            int updatedCount = service.syncFromApi();

            // 성공 메시지 설정
            String msg = "동기화 완료: " + updatedCount + "건 반영되었습니다.";
            String url = "certificationList.cert";  // 동기화 후 목록으로 이동

            request.setAttribute("board_msg", msg);
            request.setAttribute("board_url", url);

            // redirect.jsp 로 forward
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/redirect.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            // 실패 시 메시지 설정
            request.setAttribute("board_msg", "데이터 동기화 중 오류가 발생했습니다.");
            request.setAttribute("board_url", "certificationList.cert");

            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/redirect.jsp");
        }
        return forward;
    }
}
