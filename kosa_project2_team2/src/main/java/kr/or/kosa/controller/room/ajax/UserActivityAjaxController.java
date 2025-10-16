package kr.or.kosa.controller.room.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.UserActivityDao;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 사용자 활동 데이터 AJAX 전용 컨트롤러
 * JSON 응답만 처리
 */
@WebServlet("/room/ajax/useractivity.ajax")
public class UserActivityAjaxController extends HttpServlet {
    private UserActivityDao userActivityDao;
    private Gson gson;
    
    public UserActivityAjaxController() {
        this.userActivityDao = new UserActivityDao();
        this.gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        
        try {
            // 파라미터 검증
            String userIdParam = request.getParameter("userId");
            String roomIdParam = request.getParameter("roomId");
            String tabParam = request.getParameter("tab");
            String pageParam = request.getParameter("page");
            String sizeParam = request.getParameter("size");
            
            if (userIdParam == null || userIdParam.trim().isEmpty() || 
                roomIdParam == null || roomIdParam.trim().isEmpty() || 
                tabParam == null || tabParam.trim().isEmpty()) {
                
                writeErrorResponse(response, "필수 파라미터가 누락되었습니다.");
                return;
            }
            
            Long userId = Long.parseLong(userIdParam.trim());
            Long roomId = Long.parseLong(roomIdParam.trim());
            int page = parseIntParam(pageParam, 1);
            int size = parseIntParam(sizeParam, 10);
            
            // 페이지 파라미터 검증
            if (page < 1) page = 1;
            if (size < 1 || size > 100) size = 10;
            
            Map<String, Object> result = processTabRequest(userId, roomId, tabParam.trim(), page, size);
            
            if (result == null) {
                writeErrorResponse(response, "잘못된 탭 파라미터입니다.");
                return;
            }
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("data", result.get("activities"));
            responseData.put("totalCount", result.get("totalCount"));
            responseData.put("totalPages", result.get("totalPages"));
            responseData.put("currentPage", page);
            responseData.put("pageSize", size);
            responseData.put("tab", tabParam.trim());
            
            response.getWriter().write(gson.toJson(responseData));
            
        } catch (NumberFormatException e) {
            writeErrorResponse(response, "잘못된 숫자 형식입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            writeErrorResponse(response, "서버 오류가 발생했습니다.");
        }
    }
    
    /**
     * 탭별 요청 처리
     */
    private Map<String, Object> processTabRequest(Long userId, Long roomId, String tab, int page, int size) {
        switch (tab) {
            case "posts":
                return userActivityDao.getUserPosts(userId, roomId, page, size);
            case "comments":
                return userActivityDao.getUserComments(userId, roomId, page, size);
            case "commented":
                return userActivityDao.getUserCommentedPosts(userId, roomId, page, size);
            case "likes":
                return userActivityDao.getUserLikedPosts(userId, roomId, page, size);
            default:
                return null;
        }
    }
    
    /**
     * 문자열을 정수로 안전하게 변환
     */
    private int parseIntParam(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * 에러 응답 작성
     */
    private void writeErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        response.getWriter().write(gson.toJson(error));
    }
}