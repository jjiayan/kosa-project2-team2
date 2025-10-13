package kr.or.kosa.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.UUID;

public class FileUploadUtil {

    // ★ 외부 영구 저장 위치 (OS 호환)
    private static final Path BASE_DIR=Paths.get(System.getProperty("user.home"), "upload");

    static {   
        // 최초 실행 시 디렉토리 생성
        try {
            Files.createDirectories(BASE_DIR);
            System.out.println("[FileUploadUtil] 업로드 디렉토리 초기화: " + BASE_DIR.toAbsolutePath());
        } catch (IOException e) {
            System.err.println("[FileUploadUtil] 업로드 디렉토리 생성 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * URL "/files/yyyy-MM-dd/uuid.ext" 반환
     */
    public static String saveImageToUpload(Part part, ServletContext ctx) {
        try {
            if (part == null || part.getSize() == 0) return null;
            String contentType = part.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) return null; // 간단 화이트리스트

            // 날짜 디렉토리
            String dateDir = LocalDate.now().toString(); // yyyy-MM-dd
            Path dir = BASE_DIR.resolve(dateDir);
            Files.createDirectories(dir);

            if (!Files.isDirectory(dir) || !Files.isWritable(dir)) {
                throw new RuntimeException("업로드 디렉토리에 쓰기 권한이 없습니다: " + dir);
            }

            // 파일명/확장자
            String submitted = safeName(part.getSubmittedFileName());
            String ext = extOf(submitted);
            String stored = UUID.randomUUID().toString().replace("-", "") + ext;

            // 저장
            Path target = dir.resolve(stored);
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }

            System.out.println("[FileUploadUtil] 파일 저장 완료: " + target.toAbsolutePath());

            // DB에는 접근 URL만 저장
            return "/files/" + dateDir + "/" + stored;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static String safeName(String n) {
        if (n == null) return "file";
        // 경로 구분자/위험문자 제거
        String base = Paths.get(n.replace("\\", "/")).getFileName().toString();
        return base.replaceAll("[\\\\/:*?\"<>|]", "_");
    }

    private static String extOf(String name) {
        int i = name.lastIndexOf('.');
        return (i > -1) ? name.substring(i) : "";
    }
}