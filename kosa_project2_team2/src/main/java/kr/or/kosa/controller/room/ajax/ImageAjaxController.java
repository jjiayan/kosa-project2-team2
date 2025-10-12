package kr.or.kosa.controller.room.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.kosa.service.room.RoomInsertService;

import java.io.File;
import java.io.IOException;

/**
 * Servlet implementation class ImageAjaxController
 */
@WebServlet("*.imageajax")
@MultipartConfig(
	    maxFileSize = 10485760,      // 10MB
	    maxRequestSize = 20971520     // 20MB
	)
public class ImageAjaxController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ImageAjaxController() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {        
    	String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand = requestURI.substring(contextPath.length());
        
        System.out.println("이미지 요청: " + urlCommand);
        System.out.println("이미지 업로드 인증 요청 성공??? ");
        
        if(urlCommand.equals("/imageupload.imageajax")) {
        	 // 썸네일과 본문 이미지 둘 다 처리
            Part filePart = request.getPart("file");
            if (filePart == null) {
                filePart = request.getPart("thumbnail");
                System.out.println("썸네일 파라미터로 받음");
            }
            if(filePart != null && filePart.getSize() > 0) {
                // 프로젝트 소스 경로에 직접 저장
                String uploadPath = "/Users/junghunmok/upload/thumbnail/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                    System.out.println("폴더 생성: " + uploadPath);
                }
                
                
                String originalFileName = getFileName(filePart);
                String extension = "";
                int lastDot = originalFileName.lastIndexOf(".");
                if (lastDot > 0) {
                    extension = originalFileName.substring(lastDot); // .png, .jpg 등
                }
                
                // 파일명 생성 (타임스탬프 + 원본파일명)
                String fileName = System.currentTimeMillis() + "_thumbnail" + extension;
                
                // 파일 저장
                filePart.write(uploadPath + fileName);
                System.out.println("저장 완료: " + uploadPath + fileName);
                
                // 웹 접근 경로 반환
                String imageUrl = fileName;
                response.getWriter().write(imageUrl);
                
                System.out.println("반환 URL: " + imageUrl);
            } else {
                System.out.println("파일이 없음");
                response.getWriter().write("ERROR");
            }
    		
    	}

	}
    
    private String getFileName(Part filePart) {
        String contentDisp = filePart.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for(String token : tokens) {
            if(token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doProcess(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doProcess(request, response);
	}

}
