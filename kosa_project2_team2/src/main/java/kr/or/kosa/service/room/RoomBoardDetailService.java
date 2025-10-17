package kr.or.kosa.service.room;

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
		RoomBoardDto roomBoardDetail = roomDao.getRoomBoardDetail(roomBoardId, userId);
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/detailRoomBoard.jsp");
		request.setAttribute("roomBoardDetail", roomBoardDetail);
		request.setAttribute("roomBoardType", roomBoardType);
		
		return forward;
	}
	
	private void viewCountCookie(HttpServletRequest request, HttpServletResponse response, int roomBoardId) {
		String cookieName = "roomBoard_" + roomBoardId;
		
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie c : cookies) {
	            if (c.getName().equals(cookieName)) {
	                try {
	                   
	                } catch (NumberFormatException ignored) {}
	            }
	        }
	    }

	    // ✅ 조회 수 1 증가
	    

	    // ✅ 쿠키 다시 저장 (유효기간: 1일)
//	    Cookie cookie = Cookie(cookieName, String.valueOf());
//	    cookie.setPath("/"); // 모든 경로에서 접근 가능
//	    cookie.setMaxAge(60 * 60 * 24); // 24시간 유지
//	    response.addCookie(cookie);
	}
}
