package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomBoardDto;

public class RoomBoardUpdateService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		String roomBoardTitle = request.getParameter("roomBoardTitle");
		String roomBoardContent = request.getParameter("roomBoardContent");
		int roomBoardId = Integer.parseInt(request.getParameter("roomBoardId"));
		String userId = request.getParameter("userId");
		String roomBoardType = request.getParameter("roomBoardType");

		RoomDao roomDao = new RoomDao();
		
		RoomBoardDto updateRoomBoardDto = RoomBoardDto.builder()
				.roomBoardId(roomBoardId)
				.roomBoardTitle(roomBoardTitle)
				.roomBoardContent(roomBoardContent)
				.build();
		
		roomDao.updateRoomBoard(updateRoomBoardDto);
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(true);
		forward.setPath("roomboarddetail.room?roomBoardId="+roomBoardId+"&userId="+userId+"&roomBoardType="+roomBoardType);
		
		return forward;
	}

}
