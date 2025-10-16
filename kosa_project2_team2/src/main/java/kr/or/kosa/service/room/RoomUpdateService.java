package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomDto;

public class RoomUpdateService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		int userId = Integer.parseInt(request.getParameter("userId"));
		int region2 = Integer.parseInt(request.getParameter("region2"));
		int jmcd = Integer.parseInt(request.getParameter("jmcd"));
		int year = Integer.parseInt(request.getParameter("year"));
		int implseq = Integer.parseInt(request.getParameter("implseq"));
		int maxParticipant = Integer.parseInt(request.getParameter("maxParticipant"));
		String title = request.getParameter("title");
		String thumbnailUrl = request.getParameter("thumbnailUrl");
		String content = request.getParameter("content");
		
		RoomDto updateRoom = RoomDto.builder()
				.roomId(roomId)
			    .subRegionId(region2)
			    .jmcd(jmcd)
			    .year(year)
			    .implseq(implseq)
			    .maxParticipant(maxParticipant)
			    .title(title)
			    .thumbnailUrl(thumbnailUrl)
			    .content(content)
			    .build();
		
		
		
		RoomDao roomDao = new RoomDao();
		ActionForward forward = new ActionForward();
		roomDao.updateRoom(updateRoom);
		forward.setRedirect(false);

		forward.setPath("/roomdetail.room?roomId="+roomId + "&userId="+ userId);
		
		return forward;
	}

}
