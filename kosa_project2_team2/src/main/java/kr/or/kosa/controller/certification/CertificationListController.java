package kr.or.kosa.controller.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dto.Certification;
import kr.or.kosa.service.certification.CertificationListService;

import java.util.List;

/** [ 자격증 전체 목록 조회]
 *
 * ✔ 역할
 *  - CertificationListService를 호출하여 전체 자격증 데이터를 가져온다.
 *  - request에 "certificationList"라는 이름으로 데이터를 담는다.
 *  - certification_list.jsp로 forward하여 화면을 렌더링한다.
 *
 * ✔ 예외 처리
 *  - try-catch로 감싸고, 실패 시 error.jsp 또는 redirect.jsp로 이동한다.
 */
public class CertificationListController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            // 서비스 호출
            CertificationListService service = new CertificationListService();
            List<Certification> list = service.getCertificationList();

            // JSP에 데이터 전달
            request.setAttribute("certificationList", list);

            // forward 방식으로 JSP로 이동
            forward.setRedirect(false); // forward
            forward.setPath("/WEB-INF/views/certification/certification_list.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // 예외 발생 시 에러 페이지로 이동(아직 에러처리페이지 미완)
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }
        return forward;
    }
}

