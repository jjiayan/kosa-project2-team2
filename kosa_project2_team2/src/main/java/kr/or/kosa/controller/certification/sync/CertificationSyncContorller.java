package kr.or.kosa.controller.certification.sync;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

import java.io.IOException;
import java.util.List;

/**
 * ✅ API → DB 동기화 전용 컨트롤러
 * - 화면 이동 ❌
 * - JSON 목록 응답 ❌
 * - 오직 "API 호출 + DB 저장"만 수행 ✅
 * - 관리자가 직접 호출하거나, 스케줄러가 호출할 수도 있음
 */
@WebServlet("/sync/cert")
public class CertificationSyncController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CertificationDao certificationDao = new CertificationDao();
    private final ApiCertificationDao apiDao = new ApiCertificationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1️⃣ 외부 API에서 데이터 가져오기
            List<Certification> apiList = apiDao.loadCertifications();

            if (apiList == null || apiList.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                response.getWriter().write("No data returned from API");
                return;
            }

            // 2️⃣ DB에 저장 또는 갱신 (Upsert)
            int saveCount = certificationDao.upsertCertifications(apiList);

            // 3️⃣ 성공 응답
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("Sync completed: " + saveCount + " rows updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Sync failed: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
