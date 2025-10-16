package kr.or.kosa.service.certification.ajax;

import com.google.gson.Gson;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;

import java.io.IOException;
import java.util.Map;

public class CertificationCategoryAjaxService implements Action {

    private final CertificationDao dao = new CertificationDao();
    private final Gson gson = new Gson();

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        try {
            // ✅ DAO에서 grades, fields 맵으로 조회
            Map<String, Object> categories = dao.getCategories(); 
            response.getWriter().write(gson.toJson(categories));
        } catch (Exception e){
            e.printStackTrace();
            try {
                response.setStatus(500);
                response.getWriter().write("{\"error\":\"server_error\"}");
            } catch (IOException ignored){}
        }
        return null;
    }
}
