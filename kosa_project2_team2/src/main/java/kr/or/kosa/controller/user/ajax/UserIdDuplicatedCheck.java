package kr.or.kosa.controller.user.ajax;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.UserDao;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/userIdDuplicatedCheck")
public class UserIdDuplicatedCheck extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UserIdDuplicatedCheck() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String userId = request.getParameter("userId");
        Map<String, Object> result = new HashMap<>();

        if (userId == null || userId.trim().isEmpty()) {
            result.put("status", "error");
            result.put("msg", "아이디가 비어있습니다.");
        } else {
            try {
                UserDao userDao = new UserDao();
                int count = userDao.findUserByLoginId(userId);

                if (count > 0) {
                    result.put("status", "duplicate");
                    result.put("msg", "이미 사용 중인 아이디입니다.");
                } else {
                    result.put("status", "ok");
                    result.put("msg", "사용 가능한 아이디입니다.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.put("status", "error");
                result.put("msg", "서버 오류가 발생했습니다.");
            }
        }

        // Gson으로 JSON 변환
        Gson gson = new Gson();
        String json = gson.toJson(result);
        response.getWriter().write(json);
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
