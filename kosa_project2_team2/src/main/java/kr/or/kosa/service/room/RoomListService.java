package kr.or.kosa.service.room;

import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.RoomDto;
import kr.or.kosa.dto.SearchCondition;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class RoomListService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		
		String si = request.getParameter("region1");
		String siGun = request.getParameter("region2");
		String keyword = request.getParameter("keyword");
		String page = request.getParameter("page");
		String strUserId = request.getParameter("userId");
		
		int userId = 0;
		if(strUserId == null) userId = 0;
		else if(!strUserId.isEmpty() || !strUserId.equals("")) {
			userId = Integer.parseInt(request.getParameter("userId"));
		}
		
		SearchCondition searchCondition = new SearchCondition();
		searchCondition.setSi(si);
		searchCondition.setSiGun(siGun);
		searchCondition.setKeyword(keyword);
		if(page != null)
			searchCondition.setPage(Integer.parseInt(page));
		
		System.out.println("들어오는 페이지 => " + searchCondition.getPage());
		ActionForward forward = new ActionForward();
		// 검색조건 1. 시, 2. 시군, 3. 시군 제목검색 4. 제목검색		
		RoomDao roomDao = new RoomDao();
		
		PageResult<RoomDto> pageResult =  roomDao.getRoomsBySearch(searchCondition, userId);
	
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/views/room/listRoom.jsp");
		request.setAttribute("pageResult", pageResult);
		
		return forward;
	}

}



