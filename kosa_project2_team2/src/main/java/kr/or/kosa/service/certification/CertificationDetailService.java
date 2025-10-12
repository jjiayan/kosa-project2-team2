package kr.or.kosa.service.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;


public class CertificationDetailService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = null;
        CertificationDao dao = new CertificationDao();

        try {
            // 파라미터(id) 받기
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().equals("")) {
                throw new IllegalArgumentException("자격증 ID가 없습니다.");
            }

            int id = Integer.parseInt(idParam);

            // DB에서 상세 조회
            Certification certification = dao.getCertificationById(id);

            if (certification == null) {
                throw new IllegalStateException("해당 자격증이 존재하지 않습니다. ID: " + id);
            }

            // JSP에 전달
            request.setAttribute("certification", certification);

            // 페이지 이동 설정
            forward = new ActionForward();
            forward.setRedirect(false); // forward 방식
            forward.setPath("/WEB-INF/views/certification/certification_detail.jsp");

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
