package kr.or.kosa.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.*;

@WebServlet("/files/*")
public class FileServeServlet extends HttpServlet {
  private static final Path BASE_DIR = Paths.get("C:", "upload");

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String pi = req.getPathInfo();  // 예) /2025-10-11/a1.png
    if (pi == null || "/".equals(pi)) { resp.sendError(404); return; }

    // 1) 디코딩
    String decoded = java.net.URLDecoder.decode(pi, java.nio.charset.StandardCharsets.UTF_8);

    // 2) 선행 슬래시 제거  ← 핵심
    String clean = decoded.replaceFirst("^/+", "");   // "2025-10-11/a1.png"

    // 3) 정규화
    Path requested = Paths.get(clean).normalize();
    if (requested.isAbsolute() || requested.startsWith("..")) { resp.sendError(403); return; }

    // 4) BASE_DIR 밑으로 resolve
    Path file = BASE_DIR.resolve(requested).normalize();

    // 디버그
    System.out.println("[FILES] pi=" + pi + " decoded=" + decoded +
        " clean=" + clean + " -> resolved=" + file +
        " exists=" + java.nio.file.Files.exists(file));

    if (!file.startsWith(BASE_DIR) || !java.nio.file.Files.exists(file) || java.nio.file.Files.isDirectory(file)) {
      resp.sendError(404); return;
    }

    String mime = java.nio.file.Files.probeContentType(file);
    if (mime == null) mime = "application/octet-stream";
    resp.setContentType(mime);
    resp.setContentLengthLong(java.nio.file.Files.size(file));
    java.nio.file.Files.copy(file, resp.getOutputStream());
  }
}
