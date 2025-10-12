package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomDto;

public class RoomInsertService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		ActionForward forward = new ActionForward();
		
		int region2 = Integer.parseInt(request.getParameter("region2"));
		String certificate1 = request.getParameter("certificate1");
		String certificate2 = request.getParameter("certificate2");
		String title = request.getParameter("title");
		String thumbnailUrl = request.getParameter("thumbnailUrl");
		int maxParticipant = Integer.parseInt(request.getParameter("maxParticipant"));
		String content = request.getParameter("content");
		
		RoomDto insertRoomDto = RoomDto.builder()
										.regionId(region2)
										.certificate1(certificate1)
										.certificate2(certificate2)
										.maxParticipant(maxParticipant)
										.title(title)
										.thumbnailUrl(thumbnailUrl)
										.content(content)
										.build();
		RoomDao roomDao = new RoomDao();
		int result = roomDao.insertRoom(insertRoomDto);
		if(result !=0) {
			forward.setRedirect(true);
    	    forward.setPath("roomlist.room");
		}
		return forward;
	}

}
