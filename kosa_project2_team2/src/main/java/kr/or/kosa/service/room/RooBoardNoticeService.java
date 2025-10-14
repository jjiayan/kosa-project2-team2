package kr.or.kosa.service.room;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RoomBoardDto;
import kr.or.kosa.dto.SearchCondition;

public class RooBoardNoticeService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		
		String keyword = request.getParameter("keyword");
		String page = request.getParameter("page");
		
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		String roomBoardType = "NOTICE";
		
		SearchCondition searchCondition = new SearchCondition();
		searchCondition.setKeyword(keyword);
		if (page != null && !page.trim().isEmpty()) {
	        int pageNum = Integer.parseInt(page);
	        searchCondition.setPage(pageNum);
		}
		RoomDao roomDao = new RoomDao();
		List<RoomBoardDto> roomBoardList = roomDao.getRoomBoardBySearch(searchCondition, roomId, roomBoardType);
		ActionForward forward = new ActionForward();
		
		
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/listRoomBoardnotice.jsp");
		request.setAttribute("roomBoardList", roomBoardList);
		request.setAttribute("roomId", roomId);
		return forward;
		
		
	}

}
