package kr.or.kosa.controller.reply.ajax;

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
import kr.or.kosa.dao.ReplyDao;
import kr.or.kosa.dto.ReplyDto;
import kr.or.kosa.dto.UserDto;

@WebServlet("/reply/delete.ajax")
public class ReplyDeleteController extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private ReplyDao replyDao;
	private Gson gson;
	
	public ReplyDeleteController() {
		super();
		this.replyDao = new ReplyDao();
		this.gson = new Gson();
	}

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
        	
	        // 로그인 체크
	        Long userId = getCurrentUserId(request);
	        
	        // 테스트용: 파라미터로 userId 전달 가능
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
	        }
	        
	        // 파라미터 검증
	        String replyIdStr = request.getParameter("replyId");
	        
	        if (replyIdStr == null || replyIdStr.trim().isEmpty()) {
	        	result.put("success", false);
	        	result.put("message", "댓글 ID가 필요합니다");
            }
	        
	        Long replyId = Long.parseLong(replyIdStr);
	        
	        // 권한 확인 
	        if (!checkReplyOwner(replyId, userId)) {
	        	result.put("success", false);
	        	result.put("message", "삭제 권한이 없습니다");
            }
	        
	        ReplyDto reply = new ReplyDto();
            reply.setReplyId(replyId);
            reply.setUserId(userId);

            int row = replyDao.deleteReply(reply);

            if (row > 0) {
                result.put("success", true);
	        	result.put("message", "댓글이 삭제되었습니다");
            } else {
            	result.put("success", false);
	        	result.put("message", "댓글 삭제 실패했습니다");
            }
	        
        } catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
	        result.put("message", "오류가 발생했습니다요");
		}
    	response.getWriter().write(gson.toJson(result)); 
    }
    
    // 댓글 권한 확인 
    private boolean checkReplyOwner(Long replyId, Long userId) {
    	ReplyDto reply = replyDao.selectReplyById(replyId);
        return reply != null && 
               reply.getUserId().equals(userId) && 
               "ACTIVE".equals(reply.getStatus());
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

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
