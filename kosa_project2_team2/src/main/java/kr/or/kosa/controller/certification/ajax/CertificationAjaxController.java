package kr.or.kosa.controller.certification.ajax;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dto.Certification;
import kr.or.kosa.service.certification.CertificationService;

@WebServlet("/certification/list")
public class CertificationAjaxController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CertificationService service = new CertificationService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        try {
            List<Certification> list = service.getCertifications();
            String json = gson.toJson(list);
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to fetch certifications\"}");
        }
    }
}
