package kr.or.kosa.controller.room.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.SearchCertificateDto;
import kr.or.kosa.service.room.RoomBoardDeleteService;
import kr.or.kosa.service.room.RoomSearchListService;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import com.google.gson.Gson;


@WebServlet("*.roomajax")
public class RoomAjaxController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RoomAjaxController() {
        super();
    }

	private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {        
		String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand = requestURI.substring(contextPath.length());

        System.out.println("요청: " + urlCommand);

        
        Action action = null;
        ActionForward forward = null;
        
        if(urlCommand.equals("/getsubregion.roomajax")) {
        	int parentId = Integer.parseInt(request.getParameter("parentId"));
        	System.out.println("받은 parentId: " + parentId);
        	RoomDao rd = new RoomDao();
        	List<RegionDto> subRegionList  = rd.getSubRegion(parentId);
        	
        	System.out.println("구/군 개수: " + subRegionList.size());
            
        	// JSON으로 변환
            Gson gson = new Gson();
            String json = gson.toJson(subRegionList);
            
            // 응답 설정
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print(json);
        }else if(urlCommand.equals("/searchroomlist.roomajax")) {
        	System.out.println("방 검색 비동기 시작");
        	action = new RoomSearchListService();
        	action.execute(request, response);
        	
        }else if(urlCommand.equals("/roomboarddelete.roomajax")) {
        	int roomBoardId = Integer.parseInt(request.getParameter("roomBoardId"));
    		String roomBoardType =  request.getParameter("roomBoardType"); //대기 혹시몰라 
    		int roomId = Integer.parseInt(request.getParameter("roomId"));
    		
    		RoomDao roomDao = new RoomDao();
    		int deleteCheck = roomDao.deleteRoomBoard(roomBoardId);
    		
    		if(deleteCheck > 0) {
    			response.setContentType("application/json; charset=UTF-8");
    			response.getWriter().print("{\"success\": true, \"roomId\": " + roomId + "}");
    		}
        }else if(urlCommand.equals("/roomjoin.roomajax")) {
        	int userId = Integer.parseInt(request.getParameter("userId"));
    		int roomId = Integer.parseInt(request.getParameter("roomId"));
    		
        	RoomDao roomDao = new RoomDao();
        	
        	int result = roomDao.joinRoom(userId, roomId);
        	if(result > 0) {
        		response.setContentType("application/json; charset=UTF-8");
    			response.getWriter().print("{\"success\": true, \"roomId\": " + roomId + "}");
        	}
        }else if(urlCommand.equals("/joinroomusermanage.roomajax")) {
        	int userId = Integer.parseInt(request.getParameter("userId"));
    		int roomId = Integer.parseInt(request.getParameter("roomId"));
    		String type = request.getParameter("type");
    		
    		RoomDao roomDao = new RoomDao();
    		String result = roomDao.manageRoomMember(roomId, userId, type);
    		
    		response.setContentType("application/json; charset=UTF-8");
    		response.getWriter().print("{\"success\": true, \"type\": \"" + result + "\"}");

        }else if(urlCommand.equals("/searchcertificate.roomajax")) {
        	String keyword = request.getParameter("keyword");
        	String examType = request.getParameter("examType");
        	
        	RoomDao roomDao = new RoomDao();
        	List<SearchCertificateDto> searchCertificateList = roomDao.searchcertificate(keyword, examType);
        	
        
    		
        	// JSON으로 변환
            Gson gson = new Gson();
            String json = gson.toJson(searchCertificateList);
            
            // 응답 설정
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print(json);
        }else if(urlCommand.equals("/roomdelete.roomajax")) {
        	int roomId = Integer.parseInt(request.getParameter("roomId"));
        	int userId = Integer.parseInt(request.getParameter("userId"));
        	
        	RoomDao roomDao = new RoomDao();
        	int result = roomDao.deleteRoom(roomId, userId);
        	if(result > 0) {
        		response.setContentType("application/json; charset=UTF-8");
        		response.getWriter().print("{\"success\": true}");
        	}
        	
        		
        }
        

	}
	


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

}
