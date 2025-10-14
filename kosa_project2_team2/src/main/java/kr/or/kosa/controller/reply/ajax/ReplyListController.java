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

@WebServlet("/reply/list.ajax")
public class ReplyListController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReplyDao replyDao;
	private Gson gson;
	
	public ReplyListController() {
		super();
		this.replyDao = new ReplyDao();
		this.gson = new Gson();
	}

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        
        String roomBoardIdStr = request.getParameter("roomBoardId");
        String orderBy = request.getParameter("orderBy");
        
        Long currentUserId = getCurrentUserId(request);
        
        Map<String, Object> result = new HashMap<>();
        
        if (roomBoardIdStr == null || roomBoardIdStr.trim().isEmpty()) {
        	result.put("success", false);
        	result.put("message", "게시글 ID가 필요합니다");
		} else {
			try {
				Long roomBoardId = Long.parseLong(roomBoardIdStr);
				
				// orderBy default 등록순 ASC
				if (orderBy == null || orderBy.trim().isEmpty()) {
					orderBy = "ASC";
				}
				
				// userId를 전달하여 좋아요 정보 포함
				List<ReplyDto> replies = replyDao.replyListByRoomBoardId(roomBoardId, orderBy, currentUserId);
						
				if (replies == null || replies.isEmpty()) {
	                result.put("success", true);
	                result.put("replies", new ArrayList<>());
	                result.put("totalCount", 0);
	                result.put("orderBy", orderBy);
	            }
				
				// 댓글 작성자 여부 
				for (ReplyDto reply: replies) {
					if (currentUserId != null && reply.getUserId().equals(currentUserId)) {
	                    reply.setOwner(true);
	                } else {
	                    reply.setOwner(false);
	                }
				}
				
				// 댓글 계층구조 생성
				List<ReplyDto> treeReplies = buildReplyTree(replies);
				
				// 전체 댓글 수 조회
	            int totalCount = replyDao.getReplyCnt(roomBoardId);

	            result.put("success", true);
	            result.put("replies", treeReplies);
	            result.put("totalCount", totalCount);
	            result.put("orderBy", orderBy); 
				
			} catch (Exception e) {
				e.printStackTrace();
				result.put("success", false);
		        result.put("message", "댓글 목록을 조회할 수 없습니다");
		        result.put("count", 0);
			}
		}
        
    	response.getWriter().write(gson.toJson(result)); 
    }

    // 댓글 계층구조 생성 
    private List<ReplyDto> buildReplyTree(List<ReplyDto> replies) {
		List<ReplyDto> rootReplies = new ArrayList<>();
		Map<Long, ReplyDto> replyMap = new HashMap<>();
		
		// 모든 댓글을 맵에 저장하고 대댓글 리스트 초기화
        for (ReplyDto reply : replies) {
            reply.setReplies(new ArrayList<>());
            replyMap.put(reply.getReplyId(), reply);
        }
        
        // 부모-자식 관계 설정
        for (ReplyDto reply : replies) {
            if (reply.getParentReplyId() != null && reply.getParentReplyId() > 0) {
                ReplyDto parent = replyMap.get(reply.getParentReplyId());
                if (parent != null) {
                    parent.getReplies().add(reply);
                    parent.setReplyCount(parent.getReplies().size());
                }
            } else {
                rootReplies.add(reply);
            }
        }

        return rootReplies;
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
