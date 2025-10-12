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

    // 현재 API 서버는 내 PC에서 8091 포트로 실행됨
    private static final String API_URL =
        "http://localhost:8091/qualifications_api_server/certifications";

    public List<Certification> loadCertifications() {
        List<Certification> list = null;
        HttpURLConnection conn = null;
        BufferedReader reader = null;

        try {
            URL url = new URL(API_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);
            conn.setRequestProperty("Accept", "application/json");

            int responseCode = conn.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                Gson gson = new Gson();
                list = gson.fromJson(reader, new TypeToken<List<Certification>>(){}.getType());
                System.out.println("[ApiCertificationDao] 자격증 데이터 " + list.size() + "건 로드 완료");
            } else {
                System.err.println("[ApiCertificationDao] API 응답 오류: " + responseCode);
            }

        } catch (Exception e) {
            System.err.println("[ApiCertificationDao] API 요청 실패: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (reader != null) reader.close();
                if (conn != null) conn.disconnect();
            } catch (Exception ignore) {}
        }

        return list;
    }
}
