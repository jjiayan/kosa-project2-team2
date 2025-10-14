package kr.or.kosa.controller.reply.ajax;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.dao.ReplyDao;

@WebServlet("/reply/count.ajax")
public class ReplyCountController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReplyDao replyDao;
	private Gson gson;
	
	public ReplyCountController() {
		super();
		this.replyDao = new ReplyDao();
		this.gson = new Gson();
	}

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        
        String roomBoardIdStr = request.getParameter("roomBoardId");
        Map<String, Object> result = new HashMap<>();
        

    	if (roomBoardIdStr == null || roomBoardIdStr.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "게시글 ID가 필요합니다");
            result.put("count", 0);
        } else {
        	try {
        		Long roomBoardId = Long.parseLong(roomBoardIdStr);
            	int count = replyDao.getReplyCnt(roomBoardId);
            	
            	result.put("success", true);
            	result.put("count", count);
        	} catch (Exception e) {
		        e.printStackTrace();
		        result.put("success", false);
		        result.put("message", "댓글 수를 불러올 수 없습니다");
		        result.put("count", 0);
        	}
        }
    	response.getWriter().write(gson.toJson(result));
   }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}
