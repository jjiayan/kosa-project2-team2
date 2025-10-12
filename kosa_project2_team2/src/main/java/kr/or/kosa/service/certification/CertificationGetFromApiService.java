package kr.or.kosa.service.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dto.Certification;

import java.util.List;

/**
 * - 외부 API에서 자격증 데이터를 가져와 JSP로 보여주는 서비스 (DB 저장 X)
 * - 관리자 테스트/미리보기용
 */
public class CertificationGetFromApiService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = null;
        ApiCertificationDao apiDao = new ApiCertificationDao();

        try {
            // 외부 API에서 데이터 조회
            List<Certification> apiList = apiDao.loadCertifications();

            // JSP로 전달
            request.setAttribute("apiList", apiList);

            // 포워드할 JSP 페이지 (새로 만들면 됨)
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certification_api_list.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            // 예외 발생 시 error.jsp로 이동
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }
}
