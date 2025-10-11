package kr.or.kosa.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.InputStream;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.UUID;

public class FileUploadUtil {

  /**
   * 이미지 파일을 /upload/yyyy-MM-dd/uuid.ext 로 저장하고
   * DB에는 "/upload/날짜/파일" 형태의 URL을 반환.
   */
  public static String saveImageToUpload(Part part, ServletContext ctx) {
    try {
      if (part == null || part.getSize() == 0) return null;
      String contentType = part.getContentType();
      if (contentType == null || !contentType.startsWith("image/")) return null;

      // 1) 우선 webapp 내부 /upload 경로 시도
      String base = ctx.getRealPath("/upload");

      // 2) webapp 내부 경로가 없거나 읽기 불가면, 사용자 홈 디렉토리로 대체
      if (base == null) {
        base = System.getProperty("user.home") + File.separator + "app-uploads";
      }

      // 로그로 실제 경로 확인
      System.out.println("[FileUpload] basePath=" + base);

      // 날짜 디렉토리 생성
      String dateDir = LocalDate.now().toString();  // yyyy-MM-dd
      Path dir = Paths.get(base, dateDir);
      Files.createDirectories(dir);

      // 권한 체크
      if (!Files.isDirectory(dir) || !Files.isWritable(dir)) {
        throw new RuntimeException("업로드 디렉토리에 쓰기 권한이 없습니다: " + dir);
      }

      // 파일명/확장자
      String submitted = safeName(part);
      String ext = extOf(submitted);
      String stored = UUID.randomUUID().toString().replace("-", "") + ext;

      // 저장
      Path target = dir.resolve(stored);
      try (InputStream in = part.getInputStream()) {
        Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
      }

      // DB 저장용 URL (webapp 내부일 때만 바로 정적 서빙 가능)
      // base가 getRealPath("/upload")로 시작하는 경우에만 아래 URL이 직접 접근 가능
      if (ctx.getRealPath("/upload") != null && base.equals(ctx.getRealPath("/upload"))) {
        return "/upload/" + dateDir + "/" + stored;
      } else {
        // 외부 경로에 저장했으면, /upload/* 를 서블릿으로 매핑해 서빙해야 함(아래 2) 참고)
        return "/upload/" + dateDir + "/" + stored;
      }
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  private static String safeName(Part p) {
    try {
      String n = p.getSubmittedFileName();
      return n == null ? "file" : n.replace("\\", "/");
    } catch (Throwable t) { return "file"; }
  }

  private static String extOf(String name) {
    int i = name.lastIndexOf('.');
    return (i > -1) ? name.substring(i) : "";
  }
}
