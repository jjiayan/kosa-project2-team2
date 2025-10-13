package kr.or.kosa.controller.certification.ajax;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

@WebServlet("/certificationAjax")
public class CertificationAjaxController extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private CertificationDao certificationDao = new CertificationDao();
    private ApiCertificationDao apiDao = new ApiCertificationDao();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // DB에서 먼저 조회
            List<Certification> list = certificationDao.getAllCertifications();

            // DB가 비어있으면 → API → DB 저장 → 다시 DB 조회 (fallback)
            if (list == null || list.isEmpty()) {
                System.out.println("[Ajax] DB 비어있음 → API 호출 시작");

                List<Certification> apiList = apiDao.loadCertifications();

                if (apiList != null && !apiList.isEmpty()) {
                    certificationDao.upsertCertifications(apiList);
                    System.out.println("[Ajax] API 데이터 DB 저장 완료");

                    // 다시 DB에서 조회
                    list = certificationDao.getAllCertifications();
                }
            }

            // JSON 변환
            String json = gson.toJson(list);

            // 응답 설정
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
