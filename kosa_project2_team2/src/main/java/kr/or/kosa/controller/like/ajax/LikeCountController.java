package kr.or.kosa.controller.like.ajax;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.dao.LikeDao;
import kr.or.kosa.dto.LikeDto;
import kr.or.kosa.dto.UserDto;

@WebServlet("/like/count.ajax")
public class LikeCountController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private LikeDao likeDao;
	private Gson gson;
	
	public LikeCountController() {
		super();
		this.likeDao = new LikeDao();
		this.gson = new Gson();
	}

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	response.setContentType("application/json; charset=UTF-8");
    	
    	String targetType = request.getParameter("targetType");
        String targetIdStr = request.getParameter("targetId");
        Map<String, Object> result = new HashMap<>();
        
        if (targetType == null || targetIdStr == null) {
            result.put("success", false);
            result.put("message", "필수 파라미터가 누락되었습니다");
            result.put("likeCount", 0);
            result.put("isLiked", false);
        } else {
            try {
                Long targetId = Long.parseLong(targetIdStr);
                
                // LikeDto 설정
                LikeDto like = new LikeDto();
                like.setTargetType(targetType.toUpperCase());
                like.setTargetId(targetId);
                
                // 좋아요 개수 조회
                int likeCount = likeDao.getLikeCnt(like);
                
                // 현재 사용자의 좋아요 여부 확인 (로그인한 경우만)
                Long userId = getCurrentUserId(request);
                boolean isLiked = false;
                
                // ✅ 테스트용: 파라미터로 userId 전달 가능
                String testUserIdStr = request.getParameter("userId");
                if (userId == null && testUserIdStr != null && !testUserIdStr.trim().isEmpty()) {
                    try {
                        userId = Long.parseLong(testUserIdStr);
                        System.out.println("[TEST MODE] Using userId from parameter: " + userId);
                    } catch (NumberFormatException e) {
                        System.err.println("[ERROR] Invalid userId parameter: " + testUserIdStr);
                    }
                }
                
                if (userId != null) {
                    like.setUserId(userId);
                    isLiked = likeDao.checkIsLiked(like);
                }
                
                result.put("success", true);
                result.put("likeCount", likeCount);
                result.put("isLiked", isLiked);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
                result.put("success", false);
                result.put("message", "잘못된 요청입니다");
                result.put("likeCount", 0);
                result.put("isLiked", false);
            } catch (Exception e) {
                e.printStackTrace();
                result.put("success", false);
                result.put("message", "좋아요 수를 불러올 수 없습니다");
                result.put("likeCount", 0);
                result.put("isLiked", false);
            }
        }
        
        response.getWriter().write(gson.toJson(result));
    }    

    // 현재 로그인한 유저ID 가져오기  
 	private Long getCurrentUserId(HttpServletRequest request) {
 		HttpSession session = request.getSession(false);
         if (session != null) {
             UserDto userDto = (UserDto) session.getAttribute("LOGIN_USER");
             if (userDto != null) {
                 return Long.valueOf(userDto.getUser_id());
             }
         }
         return null;
 	}
 	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
