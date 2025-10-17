package kr.or.kosa.service.user;

import jakarta.servlet.http.*;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.UserDao;
import kr.or.kosa.dto.UserDto;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class KakaoCallbackService implements Action {

    private String getRestKey(HttpServletRequest req){
        String env = System.getenv("KAKAO_REST_KEY");
        return (env != null && !env.isBlank()) ? env : req.getServletContext().getInitParameter("KAKAO_REST_KEY");
    }
    private String buildRedirectUri(HttpServletRequest req){
        String base = req.getScheme() + "://" + req.getServerName()
                + ((req.getServerPort()==80||req.getServerPort()==443) ? "" : ":"+req.getServerPort());
        return base + req.getContextPath() + "/kakao/callback.user";
    }

    @Override
    public ActionForward execute(HttpServletRequest req, HttpServletResponse resp) {
        ActionForward f = new ActionForward();
        try {
            String code  = req.getParameter("code");
            String state = req.getParameter("state");
            if (code == null || code.isBlank()){
                f.setRedirect(true); f.setPath("/login.user?error=NO_CODE"); return f;
            }

            // state 검증
            HttpSession session = req.getSession(false);
            String savedState = (session!=null) ? (String) session.getAttribute("OAUTH_STATE") : null;
            if (savedState == null || !savedState.equals(state)) {
                f.setRedirect(true); f.setPath("/login.user?error=INVALID_STATE"); return f;
            }
            if (session != null) session.removeAttribute("OAUTH_STATE");

            // 1) code -> access_token
            String tokenBody = "grant_type=authorization_code"
                    + "&client_id=" + URLEncoder.encode(getRestKey(req), StandardCharsets.UTF_8)
                    + "&redirect_uri=" + URLEncoder.encode(buildRedirectUri(req), StandardCharsets.UTF_8)
                    + "&code=" + URLEncoder.encode(code, StandardCharsets.UTF_8);

            String tokenJson = httpPost("https://kauth.kakao.com/oauth/token", tokenBody);

            JsonObject tokenObj = JsonParser.parseString(tokenJson).getAsJsonObject();
            if (tokenObj.has("error")) {
                String err = tokenObj.get("error").getAsString();
                f.setRedirect(true); f.setPath("/login.user?error="+err); return f;
            }
            String accessToken = tokenObj.has("access_token") ? tokenObj.get("access_token").getAsString() : null;
            if (accessToken == null || accessToken.isBlank()) {
                f.setRedirect(true); f.setPath("/login.user?error=NO_ACCESS_TOKEN"); return f;
            }

            // 2) 사용자 id만 확보
            String meJson = httpGetBearer("https://kapi.kakao.com/v2/user/me", accessToken);
            JsonObject meObj = JsonParser.parseString(meJson).getAsJsonObject();
            long kakaoId = meObj.has("id") ? meObj.get("id").getAsLong() : -1L;
            if (kakaoId < 0) {
                f.setRedirect(true); f.setPath("/login.user?error=INVALID_ID"); return f;
            }
            String provider = "kakao";
            String authId   = String.valueOf(kakaoId);

            // 3) 존재여부만 체크
            UserDao dao = new UserDao();
            UserDto user = dao.findByAuth(provider, authId);

            if (user != null) {
                // ✅ 기존회원 → 세션 재발급 + 로그인
                if (session != null) try { session.invalidate(); } catch (Exception ignore) {}
                HttpSession newSession = req.getSession(true);
                user.setUser_pw(null);
                newSession.setAttribute("LOGIN_USER", user);
                newSession.setAttribute("LOGIN_PROVIDER", provider);

                f.setRedirect(true);
                f.setPath("/roomlist.room"); // 로그인 성공 이동지
                return f;
            } else {
                // ❌ 신규 → 가입 페이지 (세션에 PENDING 저장)
                HttpSession s = (session != null && session.getAttribute("LOGIN_USER")==null) ? session : req.getSession(true);
                s.setAttribute("PENDING_PROVIDER", provider);
                s.setAttribute("PENDING_AUTH_ID", authId);

                f.setRedirect(true);
                f.setPath("/signup.user");
                return f;
            }
        } catch (Exception e){
            e.printStackTrace();
            f.setRedirect(true);
            f.setPath("/login.user?error=SERVER");
            return f;
        }
    }

    /* ------------ 간단 HTTP 유틸 ------------ */
    private static String httpPost(String url, String body) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        c.setConnectTimeout(10000); c.setReadTimeout(15000);
        c.setRequestMethod("POST"); c.setDoOutput(true);
        c.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        c.setRequestProperty("Accept", "application/json");
        try (OutputStream os = c.getOutputStream()) { os.write(body.getBytes(StandardCharsets.UTF_8)); }
        InputStream is = c.getResponseCode() < 400 ? c.getInputStream() : c.getErrorStream();
        String out = new String(is.readAllBytes(), StandardCharsets.UTF_8);
        c.disconnect(); return out;
    }
    private static String httpGetBearer(String url, String accessToken) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        c.setConnectTimeout(10000); c.setReadTimeout(15000);
        c.setRequestProperty("Authorization", "Bearer " + accessToken);
        c.setRequestProperty("Accept", "application/json");
        InputStream is = c.getResponseCode() < 400 ? c.getInputStream() : c.getErrorStream();
        String out = new String(is.readAllBytes(), StandardCharsets.UTF_8);
        c.disconnect(); return out;
    }
}
