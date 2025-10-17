package kr.or.kosa.service.certification;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.certification.CertificationSummaryDto;


public class CertificationListService implements Action {

    private CertificationDao certificationDao = new CertificationDao();

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            // DAO 호출 -> 현재 연도 최신 회차 + 요약 정보 리스트
            List<CertificationSummaryDto> list = certificationDao.getCurrentYearLatestCertifications();

            // JSP에서 사용할 수 있도록 request에 저장
            request.setAttribute("certList", list);

            // JSP 경로 설정
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certificationList.jsp");
            // (JSP 파일명은 상황에 따라 조정 가능)
            
        } catch (Exception e) {
            e.printStackTrace();
            // 오류시 에러 페이지로 보내거나 기본 페이지로
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }
}
