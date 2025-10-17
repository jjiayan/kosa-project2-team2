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
		int userId = Integer.parseInt(request.getParameter("userId"));
		int jmcd = Integer.parseInt(request.getParameter("jmcd"));
		int year = Integer.parseInt(request.getParameter("year"));
		int implseq = Integer.parseInt(request.getParameter("implseq"));
		String title = request.getParameter("title");
		String thumbnailUrl = request.getParameter("thumbnailUrl");
		int maxParticipant = Integer.parseInt(request.getParameter("maxParticipant"));
		String content = request.getParameter("content");
		
	
		
		RoomDto insertRoomDto = RoomDto.builder()
										.regionId(region2)
										.jmcd(jmcd)
										.year(year)
										.implseq(implseq)
										.maxParticipant(maxParticipant)
										.title(title)
										.thumbnailUrl(thumbnailUrl)
										.content(content)
										.userId(userId)
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
