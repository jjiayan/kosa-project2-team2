package kr.or.kosa.controller.certification.ajax;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dto.Certification;
import kr.or.kosa.service.certification.CertificationService;

public class CertificationAjaxController implements Action {
	private CertificationService service = new CertificationService();
    private Gson gson = new Gson();

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            List<Certification> list = service.getCertifications();
            String json = gson.toJson(list);

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Failed to fetch certifications\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }

        // Ajax는 JSP로 이동이 필요 없으니 null 반환
        return null;
    }
}
