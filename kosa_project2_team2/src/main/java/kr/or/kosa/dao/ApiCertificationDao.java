package kr.or.kosa.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * 외부 자격증 API 서버에서 JSON 데이터를 불러오는 DAO
 * (현재는 내부 더미 API 서버로부터 데이터를 가져옴)
 */
public class ApiCertificationDao {

    private static final String API_URL = "http://localhost:8090/qualifications_api_server/certifications";

    /**
     * 자격증 기본정보 리스트를 API로부터 가져옴
     * @return JsonArray (자격증 목록)
     */
    public JsonArray fetchCertifications() {
        JsonArray certifications = new JsonArray();

        try {
            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            int responseCode = conn.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                JsonObject response = JsonParser.parseReader(in).getAsJsonObject();

                // 실제 응답 구조에 맞게 body → items 추출
                if (response.has("response")) {
                    JsonObject body = response.getAsJsonObject("response").getAsJsonObject("body");
                    certifications = body.getAsJsonArray("items");
                }
                in.close();
            } else {
                System.out.println("⚠️ API 연결 실패 : 응답 코드 = " + responseCode);
            }

            conn.disconnect();

        } catch (Exception e) {
            System.out.println("🚨 API 요청 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }

        return certifications;
    }
}
