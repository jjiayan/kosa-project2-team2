package kr.or.kosa.service.room;

import java.time.Duration;
import java.time.LocalDateTime;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomBoardDto;

public class RoomBoardDetailService implements Action{
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomBoardId = Integer.parseInt(request.getParameter("roomBoardId"));
		int userId = Integer.parseInt(request.getParameter("userId"));
		String roomBoardType = request.getParameter("roomBoardType");
		
		
		
		RoomDao roomDao = new RoomDao();
		RoomBoardDto roomBoardDetail = roomDao.getRoomBoardDetail(roomBoardId, userId, viewCountCookie(request, response, roomBoardId, userId));
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/detailRoomBoard.jsp");
		request.setAttribute("roomBoardDetail", roomBoardDetail);
		request.setAttribute("roomBoardType", roomBoardType);
		
		return forward;
	}
	
	private boolean viewCountCookie(HttpServletRequest request, HttpServletResponse response, int roomBoardId, int userId) {
		String cookieName = "roomBoard_" + userId;
		String viewed = "";
		boolean viewCheck = false; // false면 이미 조회를했다.
		
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie c : cookies) {
	        	 if (cookieName.equals(c.getName())) {
	                 viewed = c.getValue();
	             }else if(c.getName().contains("roomBoard")) {
	        		 c.setMaxAge(0);
	        		 c.setPath("/");
	        	    response.addCookie(c);
	        	}
	        }
	    }
	    if (!viewed.contains(String.valueOf(roomBoardId))) {
	        if (!viewed.isEmpty()) {
	            viewed += "_";
	        }
	        viewCheck = true;
	        viewed += roomBoardId;
	    }
	   
	    // 현재 시간
	    LocalDateTime now = LocalDateTime.now();
	    // 오늘 자정(다음날 0시)
	    LocalDateTime midnight = now.toLocalDate().plusDays(1).atStartOfDay();
	    // 남은 초 계산
	    long secondsUntilMidnight = Duration.between(now, midnight).getSeconds();

	    Cookie cookie = new Cookie(cookieName, viewed);
	    cookie.setPath("/"); // 모든 경로에서 접근 가능
	    cookie.setMaxAge((int) secondsUntilMidnight); // 오늘 자정까지 유지
	    response.addCookie(cookie);
	    return viewCheck;
	}
}
