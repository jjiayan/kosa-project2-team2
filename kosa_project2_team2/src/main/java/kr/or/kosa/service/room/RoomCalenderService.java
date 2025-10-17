package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.SearchCertificateDto;

public class RoomCalenderService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		RoomDao roomDao = new RoomDao();
		SearchCertificateDto certificateDate = roomDao.getRoomCertificateDate(roomId);
		
		ActionForward forward = new ActionForward();
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/roomCertificateCalender.jsp");
		request.setAttribute("info", certificateDate);
		
		return forward;
	}

}
