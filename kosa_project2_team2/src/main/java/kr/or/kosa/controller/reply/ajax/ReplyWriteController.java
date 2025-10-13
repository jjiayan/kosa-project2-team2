package kr.or.kosa.controller.reply.ajax;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

@WebServlet("/reply/write.ajax")
public class ReplyWriteController extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private ReplyDao replyDao;
	private Gson gson;
	
	public ReplyWriteController() {
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
	        String roomBoardIdStr = request.getParameter("roomBoardId");
	        String replyContent = request.getParameter("replyContent");
	        String parentReplyIdStr = request.getParameter("parentReplyId");
	
	        if (roomBoardIdStr == null || replyContent == null || replyContent.trim().isEmpty()) {
	        	result.put("success", false);
	        	result.put("message", "필수 항목을 입력해주세요");
	        }
	        
	        // 유효성 검증
	        if (replyContent.trim().isEmpty()) {
	        	result.put("success", false);
	        	result.put("message", "댓글 내용을 입력해주세요");
	        }
	        
	        // 댓글 글자수 제한 
	        if (replyContent.length() > 3000) {
	        	result.put("success", false);
	        	result.put("message", "댓글은 3000자를 초과할 수 없습니다");
	        }
	        
	        ReplyDto reply = new ReplyDto();
	        reply.setUserId(userId);
	        reply.setRoomBoardId(Long.parseLong(roomBoardIdStr));
	        reply.setReplyContent(replyContent.trim());
	        
	        // 대댓글인 경우
	        if (parentReplyIdStr != null && !parentReplyIdStr.trim().isEmpty()) {
	            reply.setParentReplyId(Long.parseLong(parentReplyIdStr));
	        }
	
	        int row = replyDao.insertReply(reply);
	
	        if (row > 0) {
	            int replyCount = replyDao.getReplyCnt(reply.getRoomBoardId());
	            result.put("success", true);
	        	result.put("message", "댓글이 등록되었습니다");
	            result.put("totalCount", replyCount);
	        } else {
	        	result.put("success", false);
	            result.put("message", "댓글 등록 실패");
	        }
        } catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
	        result.put("message", "오류가 발생했습니다요");
	        result.put("count", 0);
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

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
