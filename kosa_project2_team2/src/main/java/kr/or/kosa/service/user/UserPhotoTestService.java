package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;
import kr.or.kosa.dto.UserDto;

public class UserPhotoTestService implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();
        
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/views/user/photo-test.jsp");
        try {
            UserDao dao = new UserDao();
            UserDto user = dao.findByNickname("mok"); // ★ 고정
            request.setAttribute("user", user);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return forward;
    }
}
