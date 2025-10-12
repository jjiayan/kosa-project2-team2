package kr.or.kosa.service.certification;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

import com.google.gson.Gson;

/**
 * ✅ AJAX 전용 서비스 (JSON 응답)
 * - 인증 목록을 JSON으로 반환
 * - JSP로 Forward하지 않음 (return null)
 */
public class CertificationAjaxListService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            // 1. DB에서 전체 목록 조회
            CertificationDao dao = new CertificationDao();
            List<Certification> list = dao.getAllCertifications();

            // 2. JSON 변환
            Gson gson = new Gson();
            String json = gson.toJson(list);

            // 3. 응답 설정 후 전송
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Failed to fetch data\"}");
            } catch (IOException ignored) {}
        }

        // ✅ AJAX는 페이지 이동이 없으므로 null 반환
        return null;
    }
}
