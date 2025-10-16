package kr.or.kosa.service.room;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserActivityDao;
import kr.or.kosa.dto.UserDto;

import java.util.Map;

public class UserActivityService implements Action {
    
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {
        ActionForward forward = new ActionForward();
        
        try {
            String userIdParam = request.getParameter("userId");
            String roomIdParam = request.getParameter("roomId");
            
            System.out.println("UserActivityService - userIdParam: " + userIdParam);
            System.out.println("UserActivityService - roomIdParam: " + roomIdParam);
            
            if (userIdParam == null || userIdParam.trim().isEmpty() || 
                roomIdParam == null || roomIdParam.trim().isEmpty()) {
                
                System.out.println("파라미터 누락");
                request.getSession().setAttribute("errorMessage", "잘못된 접근입니다.");
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/roomlist.room");
                return forward;
            }
            
            Long userId = Long.parseLong(userIdParam.trim());
            Long roomId = Long.parseLong(roomIdParam.trim());
            
            System.out.println("파싱된 값 - userId: " + userId + ", roomId: " + roomId);
            
            HttpSession session = request.getSession();
            UserDto currentUser = (UserDto) session.getAttribute("LOGIN_USER");
            
            if (currentUser == null) {
                System.out.println("로그인 사용자가 없음");
                request.getSession().setAttribute("errorMessage", "로그인이 필요합니다.");
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/login.user");
                return forward;
            }
            
            UserActivityDao userActivityDao = new UserActivityDao();
            
            // 대상 사용자 정보 조회
            UserDto targetUser = userActivityDao.getUserInfo(userId);
            System.out.println("조회된 사용자: " + (targetUser != null ? targetUser.getUser_nickname() : "null"));
            
            if (targetUser == null || !"ACTIVE".equals(targetUser.getUser_status())) {
                System.out.println("사용자를 찾을 수 없음 또는 비활성 상태");
                request.getSession().setAttribute("errorMessage", "존재하지 않는 사용자입니다.");
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/roomlist.room");
                return forward;
            }
            
            // 모임방 정보 조회
            Map<String, Object> roomInfo = userActivityDao.getRoomInfo(roomId);
            String roomTitle = (String) roomInfo.get("roomTitle");
            
            System.out.println("조회된 방 제목: " + roomTitle);
            
            if (roomTitle == null) {
                System.out.println("모임방을 찾을 수 없음");
                request.getSession().setAttribute("errorMessage", "존재하지 않는 모임방입니다.");
                forward.setRedirect(true);
                forward.setPath(request.getContextPath() + "/roomlist.room");
                return forward;
            }
            
            // 사용자의 방 내 역할 조회 (room_tier 포함)
            Map<String, String> userRoleInfo = userActivityDao.getUserRoleInRoom(userId, roomId);
            String userRole = userRoleInfo.get("role");
            String userTier = userRoleInfo.get("tier");
            
            System.out.println("사용자 역할: " + userRole + ", 티어: " + userTier);
            
            // 연령대 계산
            String ageGroup = calculateAgeGroup(targetUser.getAge_group());
            System.out.println("사용자 연령대: " + targetUser.getAge_group() + ", 변환된 연령대: " + ageGroup);
            
            // 요청 속성 설정
            request.setAttribute("userInfo", targetUser);
            request.setAttribute("targetUserId", userId);
            request.setAttribute("roomId", roomId);
            request.setAttribute("roomTitle", roomTitle);
            request.setAttribute("userRole", userRole);
            request.setAttribute("userTier", userTier);
            request.setAttribute("ageGroup", ageGroup);
            request.setAttribute("currentUserId", currentUser.getUser_id());
            request.setAttribute("isMyActivity", currentUser.getUser_id() == userId.intValue());
            
            System.out.println("모든 검증 완료, JSP로 포워드");
            
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/room/userActivity.jsp");
            
        } catch (NumberFormatException e) {
            System.out.println("숫자 형식 오류: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "잘못된 요청 형식입니다.");
            forward.setRedirect(true);
            forward.setPath(request.getContextPath() + "/roomlist.room");
        } catch (Exception e) {
            System.out.println("예상치 못한 오류: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "서버 오류가 발생했습니다.");
            forward.setRedirect(true);
            forward.setPath(request.getContextPath() + "/roomlist.room");
        }
        
        return forward;
    }
    
    /**
     * 연령대 계산
     */
    private String calculateAgeGroup(int ageGroup) {
        if (ageGroup <= 0) return "정보 없음";
        
        switch (ageGroup) {
            case 10: return "10대";
            case 20: return "20대";
            case 30: return "30대";
            case 40: return "40대";
            case 50: return "50대";
            case 60: return "60대 이상";
            default: return ageGroup + "대";
        }
    }
}