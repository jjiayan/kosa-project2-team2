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

@WebServlet("/like/action.ajax")
public class LikeActionController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private LikeDao likeDao;
    private Gson gson;
    
    public LikeActionController() {
        super();
        this.likeDao = new LikeDao();
        this.gson = new Gson();
    }
    
    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 로그인 체크
            Long userId = getCurrentUserId(request);
            
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
            
            if (userId == null) {
                result.put("success", false);
                result.put("message", "로그인이 필요합니다");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            // 파라미터 가져오기
            String targetType = request.getParameter("targetType");
            String targetIdStr = request.getParameter("targetId");
            
            if (targetType == null || targetIdStr == null) {
                result.put("success", false);
                result.put("message", "필수 파라미터가 누락되었습니다");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            Long targetId = Long.parseLong(targetIdStr);
            
            // LikeDto 설정
            LikeDto like = new LikeDto();
            like.setTargetType(targetType.toUpperCase());
            like.setTargetId(targetId);
            like.setUserId(userId);
            
            // 좋아요 존재 여부 확인
            boolean isLiked = likeDao.checkIsLiked(like);
            
            String action;
            if (isLiked) {
                // 좋아요 삭제
                likeDao.deleteLike(like);
                action = "unliked";
            } else {
                // 좋아요 추가
                likeDao.insertLike(like);
                action = "liked";
            }
            
            // 업데이트된 좋아요 개수 조회
            int likeCount = likeDao.getLikeCnt(like);
            
            result.put("success", true);
            result.put("action", action);
            result.put("likeCount", likeCount);
            result.put("isLiked", !isLiked);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "잘못된 요청입니다");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "좋아요 처리 중 오류가 발생했습니다");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    // 현재 로그인한 사용자 ID 가져오기
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
