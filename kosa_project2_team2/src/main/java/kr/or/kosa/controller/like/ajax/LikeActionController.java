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
	// 세션 기반 중복 방지 상수
    private static final String SESSION_LIKE_PREFIX = "LIKE_PROCESSING_";
    private static final long LIKE_COOLDOWN_MS = 1000; // 1초 쿨다운
    private static final int MAX_LIKE_PER_MINUTE = 30; // 분당 최대 좋아요 수
    
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

         // 세션 기반 중복 요청 및 쿨다운 체크
         String sessionKey = SESSION_LIKE_PREFIX + targetType + "_" + targetId;
         HttpSession session = request.getSession();

         // 마지막 요청 시간 체크
         Long lastRequestTime = (Long) session.getAttribute(sessionKey);
         long currentTime = System.currentTimeMillis();

         if (lastRequestTime != null && 
             (currentTime - lastRequestTime) < LIKE_COOLDOWN_MS) {
             result.put("success", false);
             result.put("message", "잠시 후 다시 시도해주세요 (1초 대기)");
             response.getWriter().write(gson.toJson(result));
             return;
         }

         // 분당 요청 수 체크 (abuse 방지)
         String countKey = SESSION_LIKE_PREFIX + "COUNT_" + userId;
         Integer requestCount = (Integer) session.getAttribute(countKey);
         Long countResetTime = (Long) session.getAttribute(countKey + "_RESET");

         if (countResetTime == null || (currentTime - countResetTime) >= 60000) {
             // 1분 경과 또는 첫 요청 - 카운트 리셋
             session.setAttribute(countKey, 1);
             session.setAttribute(countKey + "_RESET", currentTime);
         } else {
             // 1분 내 요청 - 카운트 증가 및 체크
             requestCount = (requestCount == null) ? 1 : requestCount + 1;
             if (requestCount > MAX_LIKE_PER_MINUTE) {
                 result.put("success", false);
                 result.put("message", "너무 많은 요청입니다. 잠시 후 다시 시도해주세요");
                 response.getWriter().write(gson.toJson(result));
                 return;
             }
             session.setAttribute(countKey, requestCount);
         }

         // 현재 시간을 세션에 저장
         session.setAttribute(sessionKey, currentTime);

         // LikeDto 설정
         LikeDto like = new LikeDto();
            like.setTargetType(targetType.toUpperCase());
            like.setTargetId(targetId);
            like.setUserId(userId);
            
            // 좋아요 존재 여부 확인
            boolean isLiked = likeDao.checkIsLiked(like);
            
            String action;
            int operationResult = 0;

            try {
                if (isLiked) {
                    // 좋아요 삭제
                    operationResult = likeDao.deleteLike(like);
                    if (operationResult > 0) {
                        action = "unliked";
                    } else {
                        result.put("success", false);
                        result.put("message", "좋아요 취소에 실패했습니다");
                        response.getWriter().write(gson.toJson(result));
                        return;
                    }
                } else {
                    // 좋아요 추가
                    operationResult = likeDao.insertLike(like);
                    if (operationResult > 0) {
                        action = "liked";
                    } else if (operationResult == -1) {
                        // 중복 좋아요 시도
                        result.put("success", false);
                        result.put("message", "이미 좋아요를 누르셨습니다");
                        response.getWriter().write(gson.toJson(result));
                        return;
                    } else {
                        result.put("success", false);
                        result.put("message", "좋아요 추가에 실패했습니다");
                        response.getWriter().write(gson.toJson(result));
                        return;
                    }
                }
            } catch (RuntimeException e) {
                e.printStackTrace();
                result.put("success", false);
                result.put("message", "데이터베이스 처리 중 오류가 발생했습니다");
                response.getWriter().write(gson.toJson(result));
                return;
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
