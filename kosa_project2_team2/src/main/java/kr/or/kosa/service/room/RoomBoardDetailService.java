package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomBoardDto;

public class RoomBoardDetailService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		String roomBoardId = request.getParameter("roomBoardId");
		RoomDao roomDao = new RoomDao();
		RoomBoardDto roomBoardDetail = roomDao.getRoomBoardDetail(Integer.parseInt(roomBoardId));
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/detailRoomBoard.jsp");
		request.setAttribute("roomBoardDetail", roomBoardDetail);
		
		return forward;
	}

}
