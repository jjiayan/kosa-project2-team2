package kr.or.kosa.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import kr.or.kosa.dto.certification.CertificationMasterDto;
import kr.or.kosa.dto.certification.CertificationScheduleDto;
import kr.or.kosa.dto.certification.CertificationStatsDto;


// 외부 자격증 API 서버에서 JSON 데이터를 불러오는 DAO
public class ApiCertificationDao {

    // API 서버 기본 주소
    private static final String BASE_URL = "http://localhost:8091/qualifications_api_server";
    private final Gson gson = new Gson();

    public List<CertificationMasterDto> loadCertifications() {
        String url = BASE_URL + "/certifications";
        return fetchList(url, new TypeToken<List<CertificationMasterDto>>(){}.getType(), "자격증 마스터");
    }

    public List<CertificationScheduleDto> loadSchedules() {
        String url = BASE_URL + "/certifications/schedule";
        return fetchList(url, new TypeToken<List<CertificationScheduleDto>>(){}.getType(), "시험 일정");
    }

    public List<CertificationStatsDto> loadStats() {
        String url = BASE_URL + "/certifications/stats";
        return fetchList(url, new TypeToken<List<CertificationStatsDto>>(){}.getType(), "시험 통계");
    }

    // 공용 JSON Fetch 메서드
    private <T> List<T> fetchList(String apiUrl, java.lang.reflect.Type type, String label) {
        HttpURLConnection conn = null;
        BufferedReader reader = null;

        try {
            URL url = new URL(apiUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int responseCode = conn.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                List<T> list = gson.fromJson(reader, type);
                System.out.printf("[ApiCertificationDao] %s %d건 로드 완료%n", label, list.size());
                return list;
            } else {
                System.err.printf("[ApiCertificationDao] %s API 응답 오류: %d%n", label, responseCode);
            }

        } catch (Exception e) {
            System.err.printf("[ApiCertificationDao] %s API 요청 실패: %s%n", label, e.getMessage());
            e.printStackTrace();

        } finally {
            try {
                if (reader != null) reader.close();
                if (conn != null) conn.disconnect();
            } catch (Exception ignore) {}
        }

        return null;
    }
}
