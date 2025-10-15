package kr.or.kosa.service.room;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.JoinRoomUserDto;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.SearchCondition;

public class RoomMemberManageService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		String keyword = request.getParameter("keyword");
		String page = request.getParameter("page");
		
		
		SearchCondition searchCondition = new SearchCondition();
		searchCondition.setKeyword(keyword);
		if (page != null && !page.trim().isEmpty()) {
	        int pageNum = Integer.parseInt(page);
	        searchCondition.setPage(pageNum);
		}
		
		RoomDao roomDao = new RoomDao();
		PageResult<JoinRoomUserDto> pageResult = roomDao.getJoinRoomMember(roomId, searchCondition);
		
		ActionForward forward = new ActionForward();
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/roomManageForm.jsp");
		request.setAttribute("pageResult", pageResult);
		
		return forward;
	}

}
