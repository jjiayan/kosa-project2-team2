package kr.or.kosa.controller.room.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.kosa.utils.FileUploadUtil;

import java.io.IOException;

/**
 * 이미지 업로드 AJAX 컨트롤러
 * - 반환값: /files/yyyy-MM-dd/uuid.ext (텍스트)
 * - 실제 파일 저장 위치는 FileUploadUtil 규칙에 따름
 *   (web.xml context-param(upload.base) > 환경변수 UPLOAD_BASE > {user.home}/upload)
 */
@WebServlet("*.imageajax")
@MultipartConfig(
    maxFileSize = 10 * 1024 * 1024,     // 10MB
    maxRequestSize = 20 * 1024 * 1024   // 20MB
)
public class ImageAjaxController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ImageAjaxController() { super(); }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestURI  = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand  = requestURI.substring(contextPath.length());

        System.out.println("[ImageAjax] url = " + urlCommand);

        if ("/imageupload.imageajax".equals(urlCommand)) {
            // 1) 업로드 파트 찾기 (에디터/폼 마다 파라미터명이 다를 수 있어 순차 탐색)
            Part part = null;
            String[] candidates = {"file", "thumbnail", "image", "upload"};
            for (String name : candidates) {
                part = request.getPart(name);
                if (part != null && part.getSize() > 0) {
                    System.out.println("[ImageAjax] part name = " + name + ", size = " + part.getSize());
                    break;
                }
            }

            response.setCharacterEncoding("UTF-8");

            if (part == null || part.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write("ERROR: no-file");
                return;
            }

            // 2) 저장 (실제 물리 경로/권한/OS 차이는 FileUploadUtil이 처리)
            String savedWebPath = FileUploadUtil.saveImageToUpload(part, getServletContext());
            // 예) /files/2025-10-14/0c9b1f2a3b4c.png

            if (savedWebPath == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write("ERROR: invalid-file");
                return;
            }

            // 3) 클라이언트로 "웹 경로" 그대로 반환 (DB에는 이 문자열 그대로 저장)
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write(savedWebPath);
            System.out.println("[ImageAjax] saved -> " + savedWebPath);
            return;
        }

        // 정의되지 않은 경로
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }
}
