package kr.or.kosa.service.certification.ajax;

import java.util.List;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.certification.CertificationSummaryDto;

public class CertificationFilterAjaxService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        try {
            // 1) 파라미터 받기
            String grade = request.getParameter("grade");
            String field = request.getParameter("field");
            String keyword = request.getParameter("keyword");

            // 빈 문자열은 null 처리
            if (grade == null || grade.trim().isEmpty()) grade = null;
            if (field == null || field.trim().isEmpty()) field = null;
            if (keyword == null || keyword.trim().isEmpty()) keyword = null;

            // 2) DAO 호출 (전체 필터 결과 리스트 반환 - 페이징 없음!)
            CertificationDao dao = new CertificationDao();
            List<CertificationSummaryDto> list =
                    dao.getFilteredCertifications(grade, field, keyword);  // ✅ DAO에 이 메서드가 만들어져야 함!

            // 3) JSON 변환
            Gson gson = new Gson();
            String json = gson.toJson(list);

            // 4) 응답 설정
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print(json);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().print("{\"error\":\"server_error\"}");
            } catch (Exception ignore) {}
        }

        // Ajax이므로 JSP로 forward 하지 않음
        return null;
    }
}
