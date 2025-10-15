package kr.or.kosa.controller.user.ajax;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.*;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.UserDto;
import kr.or.kosa.dto.user.RoomCardDto;


@WebServlet("/mypage/rooms.sync")
public class MypageRoomsSyncServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");

        // 로그인 체크
        HttpSession session = req.getSession(false);
        Object loginObj = (session == null) ? null : session.getAttribute("LOGIN_USER");
        if (loginObj == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = resp.getWriter()) {
                out.write("{\"total\":0,\"items\":[]}");
            }
            return;
        }

        // 로그인 유저 ID
        long userId = 0;
        try {
            // DTO에 맞춰서 꺼내세요: 예) ((UserDto)loginObj).getUser_id()
            userId = (long) (Integer) req.getSession().getAttribute("LOGIN_USER_ID"); // 없으면 ↓ 라인처럼
        } catch (Exception ignore) { /* 아래에서 세션 DTO에서 꺼내기 */}
        if (userId == 0) {
            try {
                UserDto u = (UserDto) loginObj;
                userId = u.getUser_id();
            } catch (Exception e) { /* ignore */ }
        }

        // 파라미터
        String tab  = nvl(req.getParameter("tab"), "joined"); // joined|hosted
        String q    = trimToNull(req.getParameter("q"));
        String sort = nvl(req.getParameter("sort"), "recent"); // recent|popular|old
        int size    = parseIntOr(req.getParameter("size"), 10);
        int page    = parseIntOr(req.getParameter("page"), 1);

        if (size <= 0) size = 10;
        if (size > 50) size = 50;
        if (page <= 0) page = 1;

        try (PrintWriter out = resp.getWriter()) {
            RoomDao dao = new RoomDao();

            int total = dao.countMyRooms(userId, tab, (q == null ? "" : q));
            List<RoomCardDto> items = dao.findMyRooms(userId, tab, (q == null ? "" : q), sort, size, page);

            // JSON 수동 직렬화 (외부 라이브러리 없이)
            StringBuilder sb = new StringBuilder(4096);
            sb.append("{\"total\":").append(total).append(",\"items\":[");
            for (int i = 0; i < items.size(); i++) {
                RoomCardDto r = items.get(i);
                if (i > 0) sb.append(',');
                sb.append('{')
                  .append("\"roomId\":").append(r.getRoomId()).append(',')
                  .append("\"title\":\"").append(esc(r.getTitle())).append("\",")
                  .append("\"certName\":\"").append(esc(r.getCertName())).append("\",")
                  .append("\"parentRegion\":\"").append(esc(r.getParentRegion())).append("\",")
                  .append("\"childRegion\":\"").append(esc(r.getChildRegion())).append("\",")
                  .append("\"updatedAt\":\"").append(esc(r.getUpdatedAt())).append("\",")
                  .append("\"participantCount\":").append(r.getParticipantCount()).append(',')
                  .append("\"maxParticipant\":").append(r.getMaxParticipant()).append(',')
                  .append("\"likeCount\":").append(r.getLikeCount()).append(',')
                  .append("\"liked\":").append(r.isLiked()).append(',')
                  .append("\"thumbnailUrl\":\"").append(esc(nullToEmpty(r.getThumbnailUrl()))).append("\",")
                  .append("\"status\":\"").append(esc(nullToEmpty(r.getStatus()))).append("\"")
                  .append('}');
            }
            sb.append("]}");
            out.write(sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = resp.getWriter()) {
                out.write("{\"total\":0,\"items\":[]}");
            }
        }
    }

    private static String nvl(String s, String d){ return (s==null||s.isEmpty())? d : s; }
    private static String nullToEmpty(String s){ return (s==null)? "" : s; }
    private static String trimToNull(String s){
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
    private static int parseIntOr(String s, int d){
        try { return Integer.parseInt(s); } catch(Exception e){ return d; }
    }
    private static String esc(String s){
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"")
                .replace("\r","\\r").replace("\n","\\n");
    }
}