package kr.or.kosa.service.user;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;
import kr.or.kosa.dto.UserDto;
import kr.or.kosa.utils.FileUploadUtil;
import kr.or.kosa.utils.SHA256;


public class UserSignupService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = null;

        try {
        	Part avatar = request.getPart("avatarFile");
            String photoUrl = null;
            if (avatar != null && avatar.getSize() > 0) {
                photoUrl = FileUploadUtil.saveImageToUpload(avatar, request.getServletContext());
            }

            String loginId  = request.getParameter("userId");
            String pw       = request.getParameter("password");
            String encPw = SHA256.encodeSha256(pw);
            String nickname = request.getParameter("nickname");
            String bio      = request.getParameter("bio");
            String phone    = request.getParameter("phone").replaceAll("[^0-9]", ""); // 하이픈 제거

           

            UserDto user = new UserDto();
            user.setUser_login_id(loginId);
            user.setUser_pw(encPw);
            user.setUser_status("ACTIVE");
            user.setUser_nickname(nickname);
            user.setUser_bio(bio);
            user.setUser_phonenumber(phone);
            user.setUser_photo(photoUrl);

            UserDao dao = new UserDao();
            int result = dao.insertUser(user);

            String msg, url = "login.user";
            if (result > 0) {
                msg = "회원가입 성공";
            } else {
                msg = "회원가입 실패";
            }

            request.setAttribute("board_msg", msg);
            request.setAttribute("board_url", url);

            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/redirect.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return forward;
    }
}
