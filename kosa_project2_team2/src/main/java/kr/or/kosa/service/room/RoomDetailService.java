package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomDto;

public class RoomDetailService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		RoomDao roomDao = new RoomDao();
		
		RoomDto roomDetail = roomDao.detialRoom(roomId);
		ActionForward forward = new ActionForward();
		
		request.setAttribute("roomDetail", roomDetail);
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/detailRoom.jsp");

		return forward;
	}

}
