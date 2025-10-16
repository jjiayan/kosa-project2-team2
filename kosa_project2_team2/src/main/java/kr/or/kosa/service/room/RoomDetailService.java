package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomDto;

public class RoomDetailService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		String strUserId = request.getParameter("userId");
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		int userId = 0;
		if(!strUserId.isEmpty() || !strUserId.equals("")) {
			userId = Integer.parseInt(request.getParameter("userId"));
		}
		 
		
		
		// 세션에 현재 방 ID 저장 (덮어쓰기)
        
		
		RoomDao roomDao = new RoomDao();
		
		RoomDto roomDetail = roomDao.detialRoom(roomId, userId);
		ActionForward forward = new ActionForward();
		
		HttpSession session = request.getSession();
        session.setAttribute("currentRoomId", roomId);
        session.setAttribute("leaderCheck", roomDetail.isLeaderCheck());
        System.out.println(roomDetail.isLeaderCheck());
	
		
		request.setAttribute("roomDetail", roomDetail);
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/detailRoom.jsp");

		return forward;
	}

}
