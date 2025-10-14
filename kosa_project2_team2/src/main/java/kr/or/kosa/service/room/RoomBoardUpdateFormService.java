package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomBoardDto;

public class RoomBoardUpdateFormService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomBoardId = Integer.parseInt(request.getParameter("roomBoardId"));
		String roomBoardType = request.getParameter("roomBoardtype");
		
		RoomDao roomDao = new RoomDao();
		
		RoomBoardDto updateInfoRoomDto = roomDao.getUpdateInfoRoomDetail(roomBoardId, roomBoardType);
		
		
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/updateRoomBoardForm.jsp");
		request.setAttribute("roomBoard", updateInfoRoomDto);
		
		return forward;
		
	}

}
