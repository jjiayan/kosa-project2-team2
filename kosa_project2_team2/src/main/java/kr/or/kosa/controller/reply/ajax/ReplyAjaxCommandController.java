package kr.or.kosa.controller.reply.ajax;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
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

// command: 댓글 작성, 수정, 삭제 
@WebServlet("/reply/command")
public class ReplyAjaxCommandController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReplyService replyService;
	private Gson gson;

	public ReplyAjaxCommandController() {
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
			case "write":
				return writeReply(request);
			case "update":
				return updateReply(request);
			case "delete":
				return deleteReply(request);
			default:
				return createErrorResponse("잘못된 요청입니다");
		}
	}
	
	/**
	 * 댓글 작성
	 */
	private Map<String, Object> writeReply(HttpServletRequest request) {
		// 로그인 체크
		Long userId = getUserId(request);
		if (userId == null) {
			return createErrorResponse("로그인이 필요합니다");
		}
		
		// 파라미터 검증
		String roomBoardIdStr = request.getParameter("roomBoardId");
		String replyContent = request.getParameter("replyContent");
		String parentReplyIdStr = request.getParameter("parentReplyId");
		
		if (roomBoardIdStr == null || replyContent == null || replyContent.trim().isEmpty()) {
			return createErrorResponse("필수 항목을 입력해주세요");
		}
		
		try {
			ReplyDto reply = new ReplyDto();
			reply.setUserId(userId);
			reply.setRoomBoardId(Long.parseLong(roomBoardIdStr));
			reply.setReplyContent(replyContent.trim());
			
			// 대댓글인 경우
			if (parentReplyIdStr != null && !parentReplyIdStr.trim().isEmpty()) {
				reply.setParentReplyId(Long.parseLong(parentReplyIdStr));
			}
			
			boolean success = replyService.writeReply(reply);
			
			if (success) {
				int replyCount = replyService.getReplyCount(reply.getRoomBoardId());
				Map<String, Object> result = createSuccessResponse("댓글이 등록되었습니다");
				result.put("totalCount", replyCount);
				return result;
			} else {
				return createErrorResponse("댓글 등록 실패");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return createErrorResponse("오류가 발생했습니다");
		}
	}
	
	/**
	 * 댓글 수정
	 */
	private Map<String, Object> updateReply(HttpServletRequest request) {
		// 로그인 체크
		Long userId = getUserId(request);
		if (userId == null) {
			return createErrorResponse("로그인이 필요합니다");
		}
		
		// 파라미터 검증
		String replyIdStr = request.getParameter("replyId");
		String replyContent = request.getParameter("replyContent");
		
		if (replyIdStr == null || replyContent == null || replyContent.trim().isEmpty()) {
			return createErrorResponse("필수 항목을 입력해주세요");
		}
		
		try {
			Long replyId = Long.parseLong(replyIdStr);
			
			// 권한 체크 (선택적)
			if (!replyService.checkReplyOwner(replyId, userId)) {
				return createErrorResponse("수정 권한이 없습니다");
			}
			
			ReplyDto reply = new ReplyDto();
			reply.setReplyId(replyId);
			reply.setUserId(userId);
			reply.setReplyContent(replyContent.trim());
			
			boolean success = replyService.updateReply(reply);
			
			if (success) {
				return createSuccessResponse("댓글이 수정되었습니다");
			} else {
				return createErrorResponse("댓글 수정 실패");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return createErrorResponse("오류가 발생했습니다");
		}
	}
	
	/**
	 * 댓글 삭제
	 */
	private Map<String, Object> deleteReply(HttpServletRequest request) {
		// 로그인 체크
		Long userId = getUserId(request);
		if (userId == null) {
			return createErrorResponse("로그인이 필요합니다");
		}
		
		// 파라미터 검증
		String replyIdStr = request.getParameter("replyId");
		
		if (replyIdStr == null || replyIdStr.trim().isEmpty()) {
			return createErrorResponse("댓글 ID가 필요합니다");
		}
		
		try {
			Long replyId = Long.parseLong(replyIdStr);
			
			// 권한 체크 (선택적)
			if (!replyService.checkReplyOwner(replyId, userId)) {
				return createErrorResponse("삭제 권한이 없습니다");
			}
			
			boolean success = replyService.deleteReply(replyId, userId);
			
			if (success) {
				return createSuccessResponse("댓글이 삭제되었습니다");
			} else {
				return createErrorResponse("댓글 삭제 실패");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return createErrorResponse("오류가 발생했습니다");
		}
	}
	
	/**
	 * 세션에서 userId 가져오기
	 */
	private Long getUserId(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			return (Long) session.getAttribute("userId");
		}
		return null;
	}
	
	/**
	 * 성공 응답 생성
	 */
	private Map<String, Object> createSuccessResponse(String message) {
		Map<String, Object> result = new HashMap<>();
		result.put("success", true);
		result.put("message", message);
		return result;
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