package kr.or.kosa.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.*;

@WebServlet("/files/*")
public class FileServeServlet extends HttpServlet {

  /** 우선순위: web.xml context-param(upload.base) > 환경변수(UPLOAD_BASE) > {user.home}/upload */
  private Path resolveBaseDir(ServletContext ctx) {
    String fromCtx = (ctx != null) ? ctx.getInitParameter("upload.base") : null;
    String fromEnv = System.getenv("UPLOAD_BASE");

    Path base = null;
    if (fromCtx != null && !fromCtx.isBlank()) {
      base = Paths.get(fromCtx);
    } else if (fromEnv != null && !fromEnv.isBlank()) {
      base = Paths.get(fromEnv);
    } else {
      base = Paths.get(System.getProperty("user.home"), "upload");
    }
    return base.toAbsolutePath().normalize();
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Path BASE_DIR = resolveBaseDir(getServletContext());

    String pi = req.getPathInfo();  // 예) /2025-10-13/a1.png
    if (pi == null || "/".equals(pi)) { resp.sendError(404); return; }

    // 1) 디코딩
    String decoded = java.net.URLDecoder.decode(pi, java.nio.charset.StandardCharsets.UTF_8);

    // 2) 선행 슬래시 제거
    String clean = decoded.replaceFirst("^/+", "");   // "2025-10-13/a1.png"

    // 3) 정규화
    Path requested = Paths.get(clean).normalize();
    if (requested.isAbsolute() || requested.startsWith("..")) { resp.sendError(403); return; }

    // 4) BASE_DIR 밑으로 resolve (절대경로)
    Path file = BASE_DIR.resolve(requested).toAbsolutePath().normalize();

    // 디버그 (절대경로로 확인)
    System.out.println("[FILES] base=" + BASE_DIR +
        "  pi=" + pi + "  decoded=" + decoded + "  clean=" + clean +
        "  -> resolved=" + file + "  exists=" + Files.exists(file));

    if (!file.startsWith(BASE_DIR) || !Files.exists(file) || Files.isDirectory(file)) {
      resp.sendError(404); return;
    }

    String mime = Files.probeContentType(file);
    if (mime == null) mime = "application/octet-stream";
    resp.setContentType(mime);
    resp.setContentLengthLong(Files.size(file));
    Files.copy(file, resp.getOutputStream());
  }
}
