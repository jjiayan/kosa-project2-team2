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

    private static final String API_URL = "http://192.168.2.24:8090/qualifications_api_server/certifications";

    public List<Certification> loadCertifications() {
	    // 자격증 리스트를 API에서 가져와 Java 객체 리스트로 변환
	    List<Certification> list = null;
	    HttpURLConnection conn = null;
	    BufferedReader reader = null;
	
	    try {
	        // 1) URL 연결
	        URL url = new URL(API_URL);
	        conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setConnectTimeout(5000); // 연결 제한 시간 (ms)
	        conn.setReadTimeout(5000);    // 읽기 제한 시간 (ms)
	        conn.setRequestProperty("Accept", "application/json");
	
	        int responseCode = conn.getResponseCode();
	
	        // 2) 응답이 정상일 때만 JSON 읽기
	        if (responseCode == HttpURLConnection.HTTP_OK) {
	            reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
	
	            // 3) JSON → List<Certification> 변환 (Gson 사용)
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