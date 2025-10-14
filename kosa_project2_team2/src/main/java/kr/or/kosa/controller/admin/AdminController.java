package kr.or.kosa.controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.admin.AdminNoticeInsertService;
import kr.or.kosa.service.admin.AdminNoticeService;
import kr.or.kosa.service.admin.AdminNoticeWriteService;

@WebServlet("*.admin")
public class AdminController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String USER_VIEW_PATH = "/WEB-INF/views/admin/";

	public AdminController() {
		super();
	}

	private void doProcess(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String uri = request.getRequestURI();
		String ctx = request.getContextPath();
		String command = uri.substring(ctx.length());

		System.out.println("📩 요청 경로: " + command);

		ActionForward forward = null;

		if (command.equals("/adminMember.admin")) { // 관리자회원관리페이지 
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath(USER_VIEW_PATH + "adminMember.jsp");
		} else if (command.equals("/adminStat.admin")) { // 관리자통계보드페이지
			forward = new ActionForward();
			forward.setRedirect(false);
			forward.setPath(USER_VIEW_PATH + "adminStat.jsp");
		} else if (command.equals("/adminNotice.admin")) { // 관리자공지사항페이지
   			    Action action = new AdminNoticeService();
     			forward = action.execute(request, response);
		} else if (command.equals("/adminNoticeInsert.admin")) { 
		    Action action = new AdminNoticeInsertService();
		    forward = action.execute(request, response);
		}
		else if (command.equals("/adminNoticeWrite.admin")) { 
		    Action action = new AdminNoticeWriteService();
		    forward = action.execute(request, response);
		}else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		if (forward != null) {
			if (forward.isRedirect()) {
				response.sendRedirect(forward.getPath());
			} else {
				request.getRequestDispatcher(forward.getPath()).forward(request, response);
			}
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doProcess(request, response);
	}

}
