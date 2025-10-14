package kr.or.kosa.service.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.CertificationDetailDto;

public class CertificationDetailService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            // 파라미터 받기
            int jmcd = Integer.parseInt(request.getParameter("jmcd"));

            String yearParam = request.getParameter("year");
            String implSeqParam = request.getParameter("implSeq");

            CertificationDao dao = new CertificationDao();
            CertificationDetailDto detailDto = null;

            if (yearParam == null || implSeqParam == null) {
                //  year/implSeq가 없으면 "올해 최신 회차" 자동 설정
                detailDto = dao.getCurrentYearLatestCertification(jmcd);
            } else {
                int year = Integer.parseInt(yearParam);
                int implSeq = Integer.parseInt(implSeqParam);

                // 지정된 회차 상세 조회 + rounds 세팅
                detailDto = dao.getDetailWithRounds(jmcd, year, implSeq);
            }

            // DTO를 request에 저장
            request.setAttribute("cert", detailDto);

            // JSP 경로 설정
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certificationDetail.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 시 에러 페이지 이동 가능
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }
}
