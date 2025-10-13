package kr.or.kosa.service.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.CertificationSummaryDto;

public class CertificationDetailService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();
        CertificationDao dao = new CertificationDao();

        try {
            //파라미터 받기 (jmcd, year, implSeq)
            String jmcdParam = request.getParameter("jmcd");
            String yearParam = request.getParameter("year");
            String implSeqParam = request.getParameter("implSeq");

            if (jmcdParam == null || yearParam == null || implSeqParam == null) {
                throw new IllegalArgumentException("잘못된 요청입니다. (필수 파라미터 누락)");
            }

            int jmcd = Integer.parseInt(jmcdParam);
            int year = Integer.parseInt(yearParam);
            int implSeq = Integer.parseInt(implSeqParam);

            // DB 상세 조회
            CertificationSummaryDto certification = dao.getCertificationDetail(jmcd, year, implSeq);

            if (certification == null) {
                throw new IllegalStateException("해당 자격증 정보를 찾을 수 없습니다.");
            }

            // JSP로 전달
            request.setAttribute("certification", certification);

            // 페이지 이동
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certification_detail.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }
}
