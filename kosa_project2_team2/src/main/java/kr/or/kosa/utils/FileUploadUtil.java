package kr.or.kosa.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.InputStream;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.UUID;

public class FileUploadUtil {

  /** 우선순위: web.xml context-param(upload.base) > 환경변수(UPLOAD_BASE) > {user.home}/upload */
  private static Path resolveBaseDir(ServletContext ctx) {
    String fromCtx = (ctx != null) ? ctx.getInitParameter("upload.base") : null;
    String fromEnv = System.getenv("UPLOAD_BASE");

    Path base;
    if (fromCtx != null && !fromCtx.isBlank()) {
      base = Paths.get(fromCtx);
    } else if (fromEnv != null && !fromEnv.isBlank()) {
      base = Paths.get(fromEnv);
    } else {
      base = Paths.get(System.getProperty("user.home"), "upload");
    }
    return base.toAbsolutePath().normalize();
  }

  /**
   * DB에는 "/files/yyyy-MM-dd/uuid.ext" 반환
   */
  public static String saveImageToUpload(Part part, ServletContext ctx) {
    try {
    	
      if (part == null || part.getSize() == 0) return null;
      String contentType = part.getContentType();
      if (contentType == null || !contentType.startsWith("image/")) return null; // 간단 화이트리스트

      Path BASE_DIR = resolveBaseDir(ctx);

      // 날짜 디렉토리 (yyyy-MM-dd)
      String dateDir = LocalDate.now().toString();
      Path dir = BASE_DIR.resolve(dateDir).toAbsolutePath().normalize();
      Files.createDirectories(dir);

      if (!Files.isDirectory(dir) || !Files.isWritable(dir)) {
        throw new RuntimeException("업로드 디렉토리에 쓰기 권한이 없습니다: " + dir);
      }

      // 파일명/확장자
      String submitted = safeName(part.getSubmittedFileName());
      String ext = extOf(submitted);
      String stored = UUID.randomUUID().toString().replace("-", "") + ext;

      // 저장 (절대경로)
      Path target = dir.resolve(stored).toAbsolutePath().normalize();
      try (InputStream in = part.getInputStream()) {
        Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
      }

      System.out.println("[Upload] base=" + BASE_DIR + "  dir=" + dir + "  saved=" + target);

      // DB에는 접근 URL만 저장 (컨텍스트는 JSP에서 붙임)
      return "/files/" + dateDir + "/" + stored;

    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  private static String safeName(String n) {
    if (n == null) return "file";
    String base = Paths.get(n.replace("\\", "/")).getFileName().toString();
    return base.replaceAll("[\\\\/:*?\"<>|]", "_");
  }
  private static String extOf(String name) {
    int i = (name != null) ? name.lastIndexOf('.') : -1;
    return (i > -1) ? name.substring(i) : "";
  }
}
