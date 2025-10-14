package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomBoardDto;

public class RoomBoardInsertService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		int userId = Integer.parseInt(request.getParameter("userId"));
		String roomBoardTitle = request.getParameter("roomBoardTitle");
		String roomBoardContent = request.getParameter("roomBoardContent");
		String roomBoardType = request.getParameter("roomBoardType");
		
		ActionForward forward = new ActionForward();
		
		RoomBoardDto insertRoomBoardDto = RoomBoardDto.builder()
				.roomId(roomId)
				.userId(userId)
				.roomBoardTitle(roomBoardTitle)
				.roomBoardContent(roomBoardContent)
				.roomBoardType(roomBoardType)
				.build();
		
		RoomDao roomDao = new RoomDao();
		int insertRoomBoardId = roomDao.insertRoomBoard(insertRoomBoardDto);
				
		forward.setRedirect(true);
		forward.setPath("roomboarddetail.room?roomBoardId="+insertRoomBoardId+"&userId="+userId+"&roomBoardType="+roomBoardType);
		
		return forward;
	}

}
