package kr.or.kosa.controller.user.ajax;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.user.MyPostSummaryDto;
import kr.or.kosa.dto.UserDto;

@WebServlet("/mypage/myposts.sync")
public class MypageMyPostsSyncServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
    resp.setContentType("application/json; charset=UTF-8");

    HttpSession session = req.getSession(false);
    Object login = (session == null) ? null : session.getAttribute("LOGIN_USER");
    if (login == null) {
      resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
      resp.getWriter().write("{\"total\":0,\"items\":[]}");
      return;
    }
    long userId = ((UserDto) login).getUser_id();

    String q    = trim(req.getParameter("q"));
    String sort = nvl(req.getParameter("sort"), "recent"); // recent|old
    int size    = parseInt(req.getParameter("size"), 10);
    int page    = parseInt(req.getParameter("page"), 1);
    if (size <= 0) size = 10;
    if (size > 50) size = 50;
    if (page <= 0) page = 1;

    try (PrintWriter out = resp.getWriter()) {
      RoomDao dao = new RoomDao();
      int total = dao.countMyPosts(userId, q);
      List<MyPostSummaryDto> items = dao.findMyPosts(userId, q, sort, size, page);

      StringBuilder sb = new StringBuilder(2048);
      sb.append("{\"total\":").append(total).append(",\"items\":[");
      for (int i = 0; i < items.size(); i++) {
        MyPostSummaryDto it = items.get(i);
        if (i > 0) sb.append(',');
        sb.append('{')
          .append("\"boardId\":").append(it.getBoardId()).append(',')
          .append("\"boardTitle\":\"").append(esc(it.getBoardTitle())).append("\",")
          .append("\"category\":\"").append(esc(nvl(it.getCategory(), ""))).append("\",")
          .append("\"likeCount\":").append(it.getLikeCount()).append(',')
          .append("\"viewCount\":").append(it.getViewCount()).append(',')
          .append("\"createdAt\":\"").append(esc(nvl(it.getCreatedAt(), ""))).append("\"")
          .append('}');
      }
      sb.append("]}");
      out.write(sb.toString());
    } catch (Exception e) {
      e.printStackTrace();
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      resp.getWriter().write("{\"total\":0,\"items\":[]}");
    }
  }

  private static String nvl(String s, String d) { return (s == null || s.isBlank()) ? d : s; }
  private static int parseInt(String s, int d) { try { return Integer.parseInt(s); } catch (Exception e) { return d; } }
  private static String trim(String s) { return (s == null) ? null : (s.trim().isEmpty() ? null : s.trim()); }
  private static String esc(String s) {
    if (s == null) return "";
    return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "\\r").replace("\n", "\\n");
  }
}