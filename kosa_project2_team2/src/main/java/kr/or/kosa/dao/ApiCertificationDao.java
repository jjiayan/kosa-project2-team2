package kr.or.kosa.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import kr.or.kosa.dto.Certification;

/**
 * 외부 자격증 API 서버에서 JSON 데이터를 불러오는 DAO
 */
public class ApiCertificationDao {

    private static final String API_URL = "http://localhost:8090/qualifications_api_server/certifications";

    /**
     * 자격증 리스트를 API에서 가져와 Java 객체 리스트로 변환
     */
    public List<Certification> loadCertifications() {
        List<Certification> certifications = null;

        try {
            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            int responseCode = conn.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

                // JSON 전체가 배열 구조라고 가정 ([{jmcd:.., jmName:..}, ...])
                Gson gson = new Gson();
                certifications = gson.fromJson(in, new TypeToken<List<Certification>>(){}.getType());

                System.out.println("[ApiCertificationDao] 자격증 " + certifications.size() + "건 로드 완료");
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
