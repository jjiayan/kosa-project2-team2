package kr.or.kosa.controller.admin.ajax;

import java.io.IOException;

import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.AdminDao;

@WebServlet("/AdminNoticeDelete")
public class AdminNoticeDeleteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminNoticeDeleteController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        JsonObject json = new JsonObject();

        try { 
            String idParam = request.getParameter("noticeId");

            if (idParam == null || idParam.trim().isEmpty()) {
                json.addProperty("status", "error");
                json.addProperty("message", "공지 ID가 누락되었습니다.");
                response.getWriter().write(json.toString());
                return;
            }

            int noticeId = Integer.parseInt(idParam);
 
            AdminDao dao = new AdminDao();
            int result = dao.deleteNotice(noticeId);
 
            if (result > 0) {
                json.addProperty("status", "success");
                json.addProperty("message", "공지사항이 삭제되었습니다.");
            } else {
                json.addProperty("status", "fail");
                json.addProperty("message", "삭제할 공지사항을 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("status", "error");
            json.addProperty("message", "서버 오류: " + e.getMessage());
        }
 
        response.getWriter().write(json.toString());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }
}
