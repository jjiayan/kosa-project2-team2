package kr.or.kosa.controller.reply.ajax;

import java.io.IOException;
import java.io.PrintWriter;
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
import kr.or.kosa.dto.ReplyDto;
import kr.or.kosa.service.reply.ReplyService;

// query: 댓글 목록 조회, 댓글 총 개수 
@WebServlet("/reply/query")
public class ReplyAjaxQueryController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReplyService replyService;
	private Gson gson;

	public ReplyAjaxQueryController() {
		super();
		this.replyService = new ReplyService();
		this.gson = new Gson();
	}
	
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		
		String action = request.getParameter("action");
		
		try (PrintWriter out = response.getWriter()) {
			Map<String, Object> result = executeAction(request, action);
			out.print(gson.toJson(result));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * action에 따라 적절한 메서드 실행
	 */
	private Map<String, Object> executeAction(HttpServletRequest request, String action) {
		switch (action) {
			case "list":
				return getReplyList(request);
			case "count":
				return getReplyCount(request);
			default:
				return createErrorResponse("잘못된 요청입니다");
		}
	}
	
	/**
	 * 목록 조회
	 */
	private Map<String, Object> getReplyList(HttpServletRequest request) {
		String roomBoardIdStr = request.getParameter("roomBoardId");
		String orderBy = request.getParameter("orderBy");
		
		Long currentUserId = getCurrentUserId(request);
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			if (roomBoardIdStr == null || roomBoardIdStr.trim().isEmpty()) {
				return createErrorResponse("게시글 ID가 필요합니다");
			}
			
			Long roomBoardId = Long.parseLong(roomBoardIdStr);
			
			// 기본값 설정
			if (orderBy == null || orderBy.trim().isEmpty()) {
				orderBy = "ASC";
			}
			
			List<ReplyDto> replies = replyService.getReplyList(roomBoardId, orderBy, currentUserId);
			
			int totalCount = replyService.getReplyCount(roomBoardId);
			
			result.put("success", true);
			result.put("replies", replies);
//			result.put("totalCount", countTotalReplies(replies));
			result.put("totalCount", totalCount);
			result.put("orderBy", orderBy);
			
		} catch (Exception e) {
			e.printStackTrace();
			return createErrorResponse("댓글 목록 조회 실패");
		}
		
		return result;
	}
	
	/**
	 * 게시글 총 댓글수 조회
	 */
	private Map<String, Object> getReplyCount(HttpServletRequest request) {
		String roomBoardIdStr = request.getParameter("roomBoardId");
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			if (roomBoardIdStr == null || roomBoardIdStr.trim().isEmpty()) {
				result.put("success", false);
				result.put("message", "게시글 ID가 필요합니다");
				result.put("count", 0);
				return result;
			}
			
			Long roomBoardId = Long.parseLong(roomBoardIdStr);
			int count = replyService.getReplyCount(roomBoardId);
			
			result.put("success", true);
			result.put("count", count);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "댓글 수 조회 실패");
			result.put("count", 0);
		}
		
		return result;
	}
	
	
	/**
	 * 현재 로그인한 사용자 ID 가져오기
	 */
	private Long getCurrentUserId(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			return (Long) session.getAttribute("userId");
		}
		return null;
	}
	
	/**
	 * 에러 응답 생성
	 */
	private Map<String, Object> createErrorResponse(String message) {
		Map<String, Object> result = new HashMap<>();
		result.put("success", false);
		result.put("message", message);
		return result;
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doProcess(request, response);
	}
}