package kr.or.kosa.controller.certification;

import com.google.gson.Gson;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dto.Certification;
import kr.or.kosa.service.certification.CertificationListService;

import java.util.List;

/** [자격증 목록 Ajax Controller]
 *
 * ✔ 역할
 *  - CertificationListService를 호출하여 전체 자격증 데이터를 조회한다.
 *  - 조회된 데이터를 JSON 형식으로 변환한다.
 *  - response.getWriter()를 통해 JSON을 직접 출력한다.
 *
 * ✔ 특징
 *  - JSP로 forward하지 않는다.
 *  - View가 아니라 JSON 데이터를 직접 반환하므로 ActionForward는 사용하지 않는다.
 *
 * ✔ 예외 처리
 *  - try-catch로 감싸고, 실패 시 500 상태코드 + JSON 에러 메시지 반환
 */
public class CertificationAjaxController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        try {
            CertificationListService service = new CertificationListService();
            List<Certification> list = service.getCertificationList();

            // JSON 변환
            Gson gson = new Gson();
            String json = gson.toJson(list);

            // JSON 응답 설정
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();

            // 예외 발생 시 JSON 형태의 에러 응답
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"error\":\"Failed to fetch certifications\"}");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        
        // JSP로 이동하지 않으므로 null 반환
        return null;
    }
}
