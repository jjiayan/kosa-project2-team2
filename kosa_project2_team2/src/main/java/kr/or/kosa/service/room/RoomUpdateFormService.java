package kr.or.kosa.service.room;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.RoomDto;

public class RoomUpdateFormService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		RoomDao roomDao = new RoomDao();
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		
		RoomDto updateRoomInfo = roomDao.updateInfoRoom(roomId);
		List<RegionDto> mainRegion = roomDao.getRegion();
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/updateRoomBoardForm.jsp");
		request.setAttribute("updateRoomInfo", updateRoomInfo);
		request.setAttribute("mainRegionList",mainRegion);
	
		return forward;
	}
}
