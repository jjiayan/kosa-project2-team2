package kr.or.kosa.controller.user.ajax;

import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.*;
import java.util.Map;

import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.UserDto;

@WebServlet("/api/mypage/rooms")
public class UserMyRoomsApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        UserDto me = (UserDto) request.getSession().getAttribute("LOGIN_USER");
        if (me == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\":\"UNAUTHORIZED\"}");
            }
            return;
        }

        int userId = me.getUser_id();
        int limit  = parseIntOrDefault(request.getParameter("limit"), 6);
        int offset = parseIntOrDefault(request.getParameter("offset"), 0);

        try (PrintWriter out = response.getWriter()) {
            RoomDao dao = new RoomDao();
            Map<String, Object> payload = dao.findMyRoomCards(userId, offset, limit);
            out.write(gson.toJson(payload));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\":\"SERVER_ERROR\"}");
            }
        }
    }

    private int parseIntOrDefault(String s, int d) {
        try { return Integer.parseInt(s); } catch (Exception e) { return d; }
    }
}