package kr.or.kosa.controller.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dto.Certification;
import kr.or.kosa.service.certification.CertificationDetailService;

/** [자격증 상세 조회 Controller]
 *
 * ✔ 역할
 *  - 요청 파라미터에서 id를 추출한다.
 *  - CertificationDetailService를 호출하여 해당 자격증 정보를 조회한다.
 *  - request에 "certification" 이라는 이름으로 데이터를 저장한다.
 *  - certification_detail.jsp 로 forward하여 상세 화면을 렌더링한다.
 *
 * ✔ 예외 처리
 *  - 파라미터 에러 또는 DB 조회 실패 시 error.jsp 또는 redirect.jsp 이동
 */
public class CertificationDetailController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().equals("")) {
                throw new IllegalArgumentException("자격증 ID가 존재하지 않습니다.");
            }

            int id = Integer.parseInt(idParam);

            // 서비스 호출
            CertificationDetailService service = new CertificationDetailService();
            Certification certification = service.getCertificationById(id);

            if (certification == null) {
                throw new IllegalStateException("해당 자격증을 찾을 수 없습니다. ID: " + id);
            }

            // JSP에 데이터 전달
            request.setAttribute("certification", certification);

            // forward 방식으로 JSP 이동
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certification_detail.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            // 예외 발생 시 에러 페이지로 이동 (임시)
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }
        return forward;
    }
}
