package kr.or.kosa.utils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.kosa.dto.UserDto;


@WebFilter("/*")
public class AuthFilter implements Filter {

    // 페이지별 권한 정보를 저장할 Map
    private Map<String, String> pageRoles = new HashMap<>();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // web.xml에서 설정한 초기 파라미터나, DB에서 페이지별 권한 정보를 가져와 설정
        // 예시: /adminPage.jsp는 관리자 권한 필요, /userPage.jsp는 "user" 권한 필요
        pageRoles.put("/adminMember.admin", "ADMIN"); 
        pageRoles.put("/adminStat.admin", "ADMIN");
        pageRoles.put("/AdminMemberAjax", "ADMIN");
        pageRoles.put("/AdminStatAjax", "ADMIN");
        pageRoles.put("/AdminNoticeDelete", "ADMIN"); 
        pageRoles.put("/roomboardlist.room", "ACTIVE,ADMIN"); 
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 1) URI에서 contextPath 제거해서 권한맵 키와 일치시키기
        String uri = httpRequest.getRequestURI();                // 예: /MyApp/adminPage.jsp
        String ctx = httpRequest.getContextPath();               // 예: /MyApp
        String path = uri.substring(ctx.length());               // 예: /adminPage.jsp

        // 권한 체크가 필요한 페이지인지 확인
        String requiredRole = pageRoles.get(path);

        if (requiredRole == null) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean authorized = false;

        if (session != null) {
            UserDto user = (UserDto) session.getAttribute("LOGIN_USER");
            if (user != null) {
                String[] roles = requiredRole.split(",");
                for (String role : roles) {
                    if (role.trim().equals(user.getUser_status())) {
                        authorized = true;
                        break;
                    }
                }
            }
        }

        if (authorized) {
            chain.doFilter(request, response);
        } else {
            // 2) 여기서 contextPath는 httpRequest로부터 얻기
            httpResponse.setCharacterEncoding("UTF-8");
            httpResponse.setContentType("text/html; charset=UTF-8");
            httpResponse.getWriter().println(
                "<script>"
              + "alert('접근 권한이 없습니다.');"
              + "location.href='" + ctx + "/roomlist.room';"
              + "</script>"
            );
            httpResponse.getWriter().flush();
            // 필수 return: 더 이상 체인을 타지 않도록
            return;
        }
    }


    @Override
    public void destroy() {
        // 필터 종료 시 처리할 내용
    }
}
