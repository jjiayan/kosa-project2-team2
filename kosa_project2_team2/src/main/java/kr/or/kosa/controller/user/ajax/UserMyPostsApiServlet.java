// UserMyPostsApiServlet.java
package kr.or.kosa.controller.user.ajax;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.UserDto;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/api/mypage/posts")
public class UserMyPostsApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final RoomDao roomDao = new RoomDao();
    private final Gson gson = new GsonBuilder().disableHtmlEscaping().create();
    private final SimpleDateFormat fmt = new SimpleDateFormat("yyyy.MM.dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        UserDto me = (UserDto) req.getSession().getAttribute("LOGIN_USER");
        if (me == null) {
            resp.setStatus(401);
            try (PrintWriter out = resp.getWriter()) {
                out.print("{\"error\":\"UNAUTHORIZED\"}");
            }
            return;
        }

        int userId = me.getUser_id();
        int limit = 10;
        try {
            String lim = req.getParameter("limit");
            if (lim != null && lim.matches("\\d+")) limit = Integer.parseInt(lim);
        } catch (Exception ignore) {}

        try (PrintWriter out = resp.getWriter()) {
            // DAO가 title/ROOM_BOARD_TITLE, roomBoardId/ROOM_BOARD_ID, createdAt/CREATED_AT ...
            List<Map<String, Object>> raw = roomDao.findRecentPostsByUser(userId, limit);

            List<Map<String, Object>> normalized = new ArrayList<>();
            for (Map<String, Object> r : raw) {
                Map<String, Object> m = new LinkedHashMap<>();

                // 🔸 게시글 ID: roomBoardId 로 통일
                Object idObj = val(r, "roomBoardId", "ROOM_BOARD_ID", "id");
                Integer roomBoardId = (idObj == null) ? null : Integer.valueOf(String.valueOf(idObj));

                String title    = str(r, "title", "ROOM_BOARD_TITLE");
                Date created    = (Date) val(r, "createdAt", "CREATED_AT");
                Integer replies = toInt(val(r, "replyCount", "REPLY_COUNT"));
                Integer views   = toInt(val(r, "viewCount", "ROOM_BOARD_VIEW_CNT"));

                // 옵션: 타입이 있으면 같이 내려줌 (없으면 빈 문자열)
                String roomBoardType = str(r, "roomBoardType", "ROOM_BOARD_TYPE");

                // 🔸 방 정보
                Object roomIdObj = val(r, "roomId", "ROOM_ID");
                Integer roomId   = (roomIdObj == null) ? null : Integer.valueOf(String.valueOf(roomIdObj));
                String roomTitle = str(r, "roomTitle", "ROOM_TITLE");

                // url 은 내려주지 않습니다.
                m.put("roomBoardId", roomBoardId);
                m.put("title", title == null ? "" : title);
                m.put("date", created == null ? "" : fmt.format(created));
                m.put("replyCount", replies == null ? 0 : replies);
                m.put("viewCount", views == null ? 0 : views);
                m.put("roomBoardType", roomBoardType == null ? "" : roomBoardType);

                m.put("roomId", roomId);
                m.put("roomTitle", roomTitle == null ? "" : roomTitle);

                normalized.add(m);
            }

            out.print(gson.toJson(normalized));
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            try (PrintWriter out = resp.getWriter()) {
                out.print("{\"error\":\"SERVER_ERROR\"}");
            }
        }
    }

    private Object val(Map<String, Object> m, String... keys){
        for (String k: keys){
            if (m.containsKey(k) && m.get(k) != null) return m.get(k);
        }
        return null;
    }
    private String str(Map<String, Object> m, String... keys){
        Object v = val(m, keys);
        return v == null ? null : String.valueOf(v);
    }
    private Integer toInt(Object o) {
        if (o == null) return 0;
        if (o instanceof Number) return ((Number) o).intValue();
        try { return Integer.parseInt(String.valueOf(o)); } catch (Exception e) { return 0; }
    }
}
