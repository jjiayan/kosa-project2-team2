package kr.or.kosa.service.user;

import jakarta.servlet.http.*;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

public class KakaoLoginService implements Action {

    private String getRestKey(HttpServletRequest req){
        String env = System.getenv("KAKAO_REST_KEY");
        return (env != null && !env.isBlank()) ? env : req.getServletContext().getInitParameter("KAKAO_REST_KEY");
    }
    private String buildRedirectUri(HttpServletRequest req){
        String base = req.getScheme() + "://" + req.getServerName()
                + ((req.getServerPort()==80||req.getServerPort()==443) ? "" : ":"+req.getServerPort());
        return base + req.getContextPath() + "/kakao/callback.user";
    }
    private String randomState(){
        byte[] b=new byte[24];
        new SecureRandom().nextBytes(b);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(b);
    }

    @Override
    public ActionForward execute(HttpServletRequest req, HttpServletResponse resp) {
        try {
            String clientId    = getRestKey(req);                // REST API 키
            String redirectUri = buildRedirectUri(req);
            String state       = randomState();

            // 세션에 state 저장(쿠키 불필요)
            HttpSession session = req.getSession(true);
            session.setAttribute("OAUTH_STATE", state);

            String authUrl = "https://kauth.kakao.com/oauth/authorize"
                    + "?response_type=code"
                    + "&client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8)
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                    + "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8);

            ActionForward f = new ActionForward();
            f.setRedirect(true);
            f.setPath(authUrl);
            return f;
        } catch (Exception e){
            e.printStackTrace();
            ActionForward f = new ActionForward();
            f.setRedirect(true);
            f.setPath("/login.user?error=KAKAO_AUTH_START_FAIL");
            return f;
        }
    }
}
