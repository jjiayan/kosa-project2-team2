package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;

public class UserFindIdService implements Action{
	 @Override
	    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
	        ActionForward f = new ActionForward();

	        try {
	            String phone = request.getParameter("phone");
	            if (phone != null) {
	                // 숫자만 남기기
	                phone = phone.replaceAll("[^0-9]", "");
	            }

	            if (phone == null || phone.length() < 10) {
	                request.setAttribute("errorMsg", "입력하신 정보가 일치하지 않습니다.");
	            } else {
	                UserDao dao = new UserDao();
	                String loginId = dao.findLoginIdByPhone(phone);

	                if (loginId == null) {
	                    request.setAttribute("errorMsg", "입력하신 정보가 일치하지 않습니다.");
	                } else {
	                    // 마스킹 없이 그대로 표시
	                    request.setAttribute("foundId", loginId);
	                }
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	            request.setAttribute("errorMsg", "처리 중 오류가 발생했습니다.");
	        }

	        f.setRedirect(false);
	        f.setPath("/WEB-INF/views/user/findId.jsp");
	        return f;
	    }

}
