package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;

public class RoomBoardDeleteService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomBoardId = Integer.parseInt(request.getParameter("roomBoardId"));
		String roomBoardType =  request.getParameter("roomBoardType"); //대기 혹시몰라 
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		
		
		RoomDao roomDao = new RoomDao();
		int deleteCheck = roomDao.deleteRoomBoard(roomBoardId);
		ActionForward forward = new ActionForward();
	
		if(deleteCheck > 0) {
			forward.setRedirect(true);
			forward.setPath("/roomboardnotice.room?roomId="+roomId);
		}
		
		return forward;
	}

}
