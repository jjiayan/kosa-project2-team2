package kr.or.kosa.service.certification;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

/**
 * 1) 먼저 DB에서 목록 조회
 * 2) 만약 DB가 비어있으면 → API에서 데이터 가져와 DB 저장
 * 3) 다시 DB에서 목록 조회 후 반환
 * 4) JSP로 forward
 */
public class CertificationListService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        
        ActionForward forward = null;
        CertificationDao dao = new CertificationDao();
        ApiCertificationDao apiDao = new ApiCertificationDao();

        try {
            // DB에서 목록 조회
            List<Certification> list = dao.getAllCertifications();

            // DB가 비어있으면 API 호출 → DB 저장 → 다시 DB 조회
            if (list == null || list.isEmpty()) {
                System.out.println("[INFO] DB가 비어 있음 → API에서 데이터 가져옵니다.");

                List<Certification> apiList = apiDao.loadCertifications();

                if (apiList != null && !apiList.isEmpty()) {
                    int result = dao.upsertCertifications(apiList);
                    System.out.println("[INFO] API 데이터 DB 반영 완료 (" + result + "건)");

                    // 다시 DB 조회
                    list = dao.getAllCertifications();
                } else {
                    System.out.println("[WARN] API에서도 데이터를 가져오지 못했습니다.");
                }
            }

            // 최종 데이터 request에 담기
            request.setAttribute("certificationList", list);

            // JSP로 forward
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certification_list.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            // 예외 발생 시 에러 페이지로 이동
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }
}
