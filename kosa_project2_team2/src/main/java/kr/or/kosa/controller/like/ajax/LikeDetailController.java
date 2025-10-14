package kr.or.kosa.controller.like.ajax;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.dao.LikeDao;
import kr.or.kosa.dto.LikeDto;
import kr.or.kosa.dto.UserDto;

@WebServlet("/like/detail.ajax")
public class LikeDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LikeDao likeDao;
    private Gson gson;
    
    public LikeDetailController() {
        super();
        this.likeDao = new LikeDao();
        // 날짜 포맷 설정
        this.gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        
        String roomBoardIdStr = request.getParameter("roomBoardId");
        
        Map<String, Object> result = new HashMap<>();
        
        if (roomBoardIdStr == null || roomBoardIdStr.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "게시글 ID가 필요합니다");
            result.put("totalCount", 0);
            result.put("likeUsers", new java.util.ArrayList<>());
        } else {
            try {
                Long roomBoardId = Long.parseLong(roomBoardIdStr);
                
                // LikeDto 설정
                LikeDto like = new LikeDto();
                like.setTargetType("ROOM_BOARD");
                like.setTargetId(roomBoardId);
                
                // 전체 좋아요 개수 조회
                int totalCount = likeDao.getLikeCnt(like);
                
                // 좋아요 누른 사용자 목록 조회
                List<LikeDto> likeUsers = likeDao.likeListByRoomBoardId(like);
                
                // 현재 사용자의 좋아요 여부 확인 (로그인한 경우만)
                Long userId = getCurrentUserId(request);
                boolean isLiked = false;
                
                if (userId != null) {
                    like.setUserId(userId);
                    isLiked = likeDao.checkIsLiked(like);
                }
                
                result.put("success", true);
                result.put("totalCount", totalCount);
                result.put("isLiked", isLiked);
                result.put("likeUsers", likeUsers);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
                result.put("success", false);
                result.put("message", "잘못된 요청입니다");
                result.put("totalCount", 0);
                result.put("likeUsers", new java.util.ArrayList<>());
            } catch (Exception e) {
                e.printStackTrace();
                result.put("success", false);
                result.put("message", "좋아요 목록을 불러올 수 없습니다");
                result.put("totalCount", 0);
                result.put("likeUsers", new java.util.ArrayList<>());
            }
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