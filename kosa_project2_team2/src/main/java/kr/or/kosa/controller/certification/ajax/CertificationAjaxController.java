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
import kr.or.kosa.service.certification.CertificationListService;


@WebServlet("/certificationAjax")  // 원하는 URL로 변경 가능 (예: /certAjax.cert 도 OK)
public class CertificationAjaxController extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private CertificationListService service = new CertificationListService();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Certification> list = service.getCertificationList();
           
            String json = gson.toJson(list);
            
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"error\":\"Failed to fetch certifications\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
