package kr.or.kosa.service.certification.ajax;

import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.CertificationSummaryDto;

public class CertificationFilterAjaxService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        try {
            // 1) 파라미터 받기
            String grade = request.getParameter("grade");
            String field = request.getParameter("field");
            String keyword = request.getParameter("keyword");

            // null 또는 빈 문자열이면 null 처리
            if (grade == null || grade.equals("")) grade = null;
            if (field == null || field.equals("")) field = null;
            if (keyword == null || keyword.trim().equals("")) keyword = null;

            // 2) DAO 호출
            CertificationDao dao = new CertificationDao();
            List<CertificationSummaryDto> list =
                    dao.getFilteredCertifications(grade, field, keyword);

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
                response.getWriter().print("{\"error\":\"서버 오류 발생\"}");
            } catch (Exception ignore) {}
        }

        // ✅ Ajax이므로 JSP로 forward X
        return null;
    }
}
