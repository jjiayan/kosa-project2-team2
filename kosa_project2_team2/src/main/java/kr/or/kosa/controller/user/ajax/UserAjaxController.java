package kr.or.kosa.controller.user.ajax;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("*.userajax")
public class UserAjaxController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UserAjaxController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	try (Connection conn = ConnectionPoolHelper.getConnection()) {
    	    if (conn != null) {
    	        System.out.println("✅ DB 연결 성공: " + conn);
    	    } else {
    	        System.out.println("❌ DB 연결 실패: conn is null");
    	    }
    	} catch (Exception e) {
    	    e.printStackTrace();
    	}

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

}
