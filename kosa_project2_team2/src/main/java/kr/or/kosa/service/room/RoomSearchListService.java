package kr.or.kosa.service.room;

import java.io.IOException;
import java.util.Iterator;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.RoomDto;
import kr.or.kosa.dto.SearchCondition;

public class RoomSearchListService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
    	String keyword = request.getParameter("keyword");
    	String region1 = request.getParameter("region1");
    	String region2 = request.getParameter("region2");
    	String page = request.getParameter("page");
    	String strUserId = request.getParameter("userId");
		int userId = 0;
		if(!strUserId.isEmpty() || !strUserId.equals("")) {
			userId = Integer.parseInt(request.getParameter("userId"));
		}
		System.out.println("userId ==>> " + userId);
    	int pageNum = (page != null && !page.trim().isEmpty()) ? Integer.parseInt(page) : 1;
    	SearchCondition searchCondition = new SearchCondition(region1, region2, keyword);
    	searchCondition.setPage(pageNum);  
    	RoomDao roomDao = new RoomDao();
    	PageResult<RoomDto> pageResult  = roomDao.getRoomsBySearch(searchCondition, userId);
    	
    	
    	// JSON으로 변환
        Gson gson = new Gson();
        String json = gson.toJson(pageResult);
        
        // 응답 설정
        response.setContentType("application/json; charset=UTF-8");
        try {
			response.getWriter().print(json);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	

}
