package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

public class RoomBoardInsertFormService implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
		int roomId = Integer.parseInt(request.getParameter("roomId"));
		String roomBoardType = request.getParameter("roomBoardType");
		ActionForward forward = new ActionForward();
		forward.setRedirect(false);
		request.setAttribute("roomId", roomId);
		request.setAttribute("roomBoardType", roomBoardType);
		forward.setPath("/WEB-INF/views/room/roomBoardInsert.jsp");
		return forward;
	}

}
