package kr.or.kosa.controller.room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.service.room.RooBoardNoticeService;
import kr.or.kosa.service.room.RoomAdminFormService;
import kr.or.kosa.service.room.RoomBoardDetailService;
import kr.or.kosa.service.room.RoomBoardInsertFormService;
import kr.or.kosa.service.room.RoomBoardInsertService;
import kr.or.kosa.service.room.RoomBoardListService;
import kr.or.kosa.service.room.RoomBoardUpdateFormService;
import kr.or.kosa.service.room.RoomBoardUpdateService;
import kr.or.kosa.service.room.RoomDetailService;
import kr.or.kosa.service.room.RoomInsertService;
import kr.or.kosa.service.room.RoomListService;
import kr.or.kosa.service.room.RoomMemberManageService;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;


@WebServlet("*.room")
public class RoomController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RoomController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand = requestURI.substring(contextPath.length());

        System.out.println("요청: " + urlCommand);
        System.out.println("방관련 성공? ");
    	
        Action action = null;
        ActionForward forward = null;
        // 모임방 만드는 화면으로 전환 여기서는 메인지역만 주고 끝
    	if(urlCommand.equals("/insertForm.room")) {
    		
//    		action = new RoomInsertService(); 
//    		forward = action.execute(request, response);
    		RoomDao rd = new RoomDao();
    		List<RegionDto> mainRegion = rd.getRegion();
    		request.setAttribute("mainRegionList",mainRegion);

    		forward = new ActionForward();
    	    forward.setRedirect(false);
    	    forward.setPath("/WEB-INF/views/room/insertRoom.jsp");
    	}else if(urlCommand.equals("/insert.room")) {
    		action = new RoomInsertService(); 
    		forward = action.execute(request, response);
    		
    	}else if(urlCommand.equals("/roomlist.room")) {
    		action = new RoomListService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomdetail.room")) { // 모임방의 정보를 보는거
    		action = new RoomDetailService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboardlist.room")) { // 룸 보드 리스트
    		action = new RoomBoardListService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboarddetail.room")) {
    		action = new RoomBoardDetailService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboardinsertform.room")) {
    		action = new RoomBoardInsertFormService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboardinsert.room")) {
    		action = new RoomBoardInsertService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboardnotice.room")) {
    		action = new RooBoardNoticeService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboardupdateform.room")) {
    		action = new RoomBoardUpdateFormService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomboardupdate.room")) {
    		action = new RoomBoardUpdateService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roomadminform.room")) {
    		action = new RoomAdminFormService();
    		forward = action.execute(request, response);
    	}else if(urlCommand.equals("/roommembermanageform.room")) {
    		action = new RoomMemberManageService();
    		forward = action.execute(request, response);
    	}
    	

    	if(forward != null) {
    		if (forward.isRedirect()) {
                // redirect (주소창 변경, 새 요청)
                response.sendRedirect(forward.getPath());
            } else {
                // forward (내부 이동, request 유지)
                request.getRequestDispatcher(forward.getPath())
                       .forward(request, response);
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
