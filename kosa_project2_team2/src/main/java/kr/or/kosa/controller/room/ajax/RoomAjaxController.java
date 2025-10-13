package kr.or.kosa.controller.room.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.kosa.dao.RoomDao;
import kr.or.kosa.dto.RegionDto;
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
        System.out.println("방정보 생성 들어온다  성공? ");
        
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
        }
        

	}
	


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

}
