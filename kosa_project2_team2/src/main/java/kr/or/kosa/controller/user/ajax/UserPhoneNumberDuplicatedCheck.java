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

@WebServlet("/UserPhoneNumberDuplicatedCheck")
public class UserPhoneNumberDuplicatedCheck extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UserPhoneNumberDuplicatedCheck() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String phone = request.getParameter("phone");
        Map<String, Object> result = new HashMap<>();

        if (phone == null || phone.trim().isEmpty()) {
            result.put("status", "error");
            result.put("msg", "전화번호가 비어있습니다.");
        } else {
            // 숫자만 추출 (DB 저장/조회 포맷 통일)
            String normalized = phone.replaceAll("[^0-9]", "");
            try {
                UserDao userDao = new UserDao();
                int count = userDao.findUserByPhoneNumber(normalized);

                if (count > 0) {
                    result.put("status", "duplicate");
                    result.put("msg", "이미 사용 중인 전화번호입니다.");
                } else {
                    result.put("status", "ok");
                    result.put("msg", "사용 가능한 전화번호입니다.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                result.put("status", "error");
                result.put("msg", "서버 오류가 발생했습니다.");
            }
        }

        String json = new Gson().toJson(result);
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
