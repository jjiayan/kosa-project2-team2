package kr.or.kosa.controller.room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.dao.UserActivityDao;
import kr.or.kosa.dto.UserDto;

import java.io.IOException;

/**
 * 사용자 활동 페이지 요청 전용 컨트롤러
 * JSP 페이지 렌더링만 처리
 */
@WebServlet("/room/useractivity.room")
public class UserActivityPageController extends HttpServlet {
    private UserActivityDao userActivityDao;
    
    public UserActivityPageController() {
        this.userActivityDao = new UserActivityDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 파라미터 검증
            String userIdParam = request.getParameter("userId");
            String roomIdParam = request.getParameter("roomId");
            
            if (userIdParam == null || userIdParam.trim().isEmpty() || 
                roomIdParam == null || roomIdParam.trim().isEmpty()) {
                
                handleError(request, response, "잘못된 접근입니다.", "/roomlist.room");
                return;
            }
            
            Long userId = Long.parseLong(userIdParam.trim());
            Long roomId = Long.parseLong(roomIdParam.trim());
            
            // 현재 로그인 사용자 확인
            HttpSession session = request.getSession();
            UserDto currentUser = (UserDto) session.getAttribute("LOGIN_USER");
            
            if (currentUser == null) {
                handleError(request, response, "로그인이 필요합니다.", "/login.user");
                return;
            }
            
            // 대상 사용자 정보 조회
            UserDto targetUser = userActivityDao.getUserInfo(userId);
            if (targetUser == null || !"ACTIVE".equals(targetUser.getUser_status())) {
                handleError(request, response, "존재하지 않는 사용자입니다.", "/roomlist.room");
                return;
            }
            
            // 요청 속성 설정
            request.setAttribute("userInfo", targetUser);
            request.setAttribute("targetUserId", userId);
            request.setAttribute("roomId", roomId);
            request.setAttribute("currentUserId", currentUser.getUser_id());
            request.setAttribute("isMyActivity", currentUser.getUser_id() == userId.intValue());
            
            // JSP 페이지로 포워드
            request.getRequestDispatcher("/WEB-INF/views/room/userActivity.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            handleError(request, response, "잘못된 요청 형식입니다.", "/roomlist.room");
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "서버 오류가 발생했습니다.", "/roomlist.room");
        }
    }
    
    /**
     * 에러 처리 및 리다이렉트
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           String errorMessage, String redirectPath) throws IOException {
        
        request.getSession().setAttribute("errorMessage", errorMessage);
        response.sendRedirect(request.getContextPath() + redirectPath);
    }
}