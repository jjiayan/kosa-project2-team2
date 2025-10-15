package kr.or.kosa.controller.user.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

import kr.or.kosa.dao.RoomDao;

@WebServlet("/room/like")
public class RoomLikeSyncServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");

        HttpSession session = req.getSession(false);
        Object loginObj = (session == null) ? null : session.getAttribute("LOGIN_USER");
        if (loginObj == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = resp.getWriter()) {
                out.write("{\"ok\":false}");
            }
            return;
        }
        long userId = 0;
        try {
            kr.or.kosa.dto.UserDto u = (kr.or.kosa.dto.UserDto) loginObj;
            userId = u.getUser_id();
        } catch (Exception ignore){}

        // JSON 본문 파싱 (roomId, isLiked)
        String body = readBody(req);
        long roomId = parseJsonLong(body, "roomId");
        boolean isLiked = parseJsonBoolean(body, "isLiked");

        boolean ok = new RoomDao().toggleLike(userId, roomId, isLiked);

        try (PrintWriter out = resp.getWriter()) {
            out.write("{\"ok\":" + ok + "}");
        }
    }

    private static String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder(512);
        try (BufferedReader br = req.getReader()) {
            String line; while ((line = br.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }
    private static long parseJsonLong(String json, String key){
        try{
            String p = "\"" + key + "\":";
            int i = json.indexOf(p);
            if (i < 0) return 0;
            i += p.length();
            int j = i;
            while (j < json.length() && "0123456789".indexOf(json.charAt(j))>=0) j++;
            return Long.parseLong(json.substring(i, j));
        }catch(Exception e){ return 0; }
    }
    private static boolean parseJsonBoolean(String json, String key){
        try{
            String p = "\"" + key + "\":";
            int i = json.indexOf(p);
            if (i < 0) return false;
            i += p.length();
            String tail = json.substring(i).trim();
            return tail.startsWith("true");
        }catch(Exception e){ return false; }
    }
}