package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import kr.or.kosa.dto.Certification;
import kr.or.kosa.utils.ConnectionPoolHelper;

/**
 * DB에 자격증 정보를 CRUD하는 DAO
 * - API에서 받아온 데이터를 DB에 upsert(삽입 또는 갱신)
 * - 로컬 DB 조회용
 */
public class CertificationDao {
	
	// 실제 API 서버 주소
    private static final String API_URL = "http://192.168.2.24:8090/qualifications_api_server/certifications";
    
    
    // 테이블 존재 여부 확인 후, 없으면 자동 생성
    public CertificationDao() {
        ensureTableExists();
    }

    private void ensureTableExists() {
        String checkSql = "SELECT COUNT(*) FROM user_tables WHERE table_name = 'CERTIFICATION'";
        String createSql =
            "CREATE TABLE certification ("
          + "jmcd NUMBER PRIMARY KEY, "
          + "jm_name VARCHAR2(100), "
          + "organ_name VARCHAR2(100), "
          + "year NUMBER(4), "
          + "impl_seq NUMBER(2), "
          + "last_updated DATE DEFAULT SYSDATE"
          + ")";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(checkSql)) {

            boolean exists = false;
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true;
            }

            if (!exists) {
                stmt.execute(createSql);
                System.out.println("[INIT] certification 테이블이 존재하지 않아 새로 생성했습니다 ✅");
            } else {
                // optional log
                System.out.println("[INIT] certification 테이블이 이미 존재합니다.");
            }

        } catch (SQLException e) {
            System.err.println("[INIT] certification 테이블 확인/생성 중 오류: " + e.getMessage());
        }
    }
    
    //API에서 자격증 데이터 가져오기
    public List<Certification> loadCertifications() {
        List<Certification> list = null;
        HttpURLConnection conn = null;
        BufferedReader reader = null;

        try {
            URL url = new URL(API_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000); // 연결 제한 시간
            conn.setReadTimeout(5000);    // 읽기 제한 시간
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
	
	// 신규 / 기존 데이터 모두 upsert
    public int upsertCertifications(List<Certification> list) {
    	String sql =
    		    "MERGE INTO certification c "
    		  + "USING (SELECT ? AS jmcd, ? AS jm_name, ? AS organ_name, ? AS year, ? AS impl_seq FROM dual) d "
    		  + "ON (c.jmcd = d.jmcd) "
    		  + "WHEN MATCHED THEN "
    		  + "    UPDATE SET c.jm_name = d.jm_name, c.organ_name = d.organ_name, "
    		  + "               c.year = d.year, c.impl_seq = d.impl_seq, "
    		  + "               c.last_updated = SYSDATE "
    		  + "WHEN NOT MATCHED THEN "
    		  + "    INSERT (jmcd, jm_name, organ_name, year, impl_seq) "
    		  + "    VALUES (d.jmcd, d.jm_name, d.organ_name, d.year, d.impl_seq)";

        int count = 0;
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (Certification c : list) {
                pstmt.setInt(1, c.getJmcd());
                pstmt.setString(2, c.getJmName());
                pstmt.setString(3, c.getOrganName());
                pstmt.setInt(4, c.getYear());
                pstmt.setInt(5, c.getImplSeq());
                pstmt.addBatch();
            }
            int[] results = pstmt.executeBatch();
            for (int r : results) count += (r >= 0 ? 1 : 0);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // DB에 저장된 자격증 전체 목록 조회
    public List<Certification> getAllCertifications() {
        List<Certification> list = new ArrayList<>();
        String sql = "SELECT jmcd, year, implSeq, jmName, organName FROM certification ORDER BY jmName ASC";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Certification c = new Certification();
                c.setJmcd(rs.getInt("jmcd"));
                c.setYear(rs.getInt("year"));
                c.setImplSeq(rs.getInt("implSeq"));
                c.setJmName(rs.getString("jmName"));
                c.setOrganName(rs.getString("organName"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * API에서 가져온 JSON 데이터를 DB에 upsert (Oracle 기준 MERGE INTO)
     * @param jsonArray API에서 받은 자격증 JSON 배열
     * @return 처리 건수
     */
    public int upsertCertifications(JsonArray jsonArray) {
        int result = 0;

        String sql =
            "MERGE INTO certification c " +
            "USING DUAL " +
            "ON (c.jmcd = ?) " +
            "WHEN MATCHED THEN " +
            "  UPDATE SET c.jmName = ?, c.organName = ?, c.year = ?, c.implSeq = ? " +
            "WHEN NOT MATCHED THEN " +
            "  INSERT (jmcd, jmName, organName, year, implSeq) " +
            "  VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (JsonElement elem : jsonArray) {
                JsonObject obj = elem.getAsJsonObject();

                int jmcd = obj.get("jmcd").getAsInt();
                String jmName = obj.get("jmName").getAsString();
                String organName = obj.get("organName").getAsString();
                int year = obj.get("year").getAsInt();
                int implSeq = obj.get("implSeq").getAsInt();

                pstmt.setInt(1, jmcd);        // MERGE 조건
                pstmt.setString(2, jmName);   // UPDATE 필드
                pstmt.setString(3, organName);
                pstmt.setInt(4, year);
                pstmt.setInt(5, implSeq);

                pstmt.setInt(6, jmcd);        // INSERT 필드
                pstmt.setString(7, jmName);
                pstmt.setString(8, organName);
                pstmt.setInt(9, year);
                pstmt.setInt(10, implSeq);

                result += pstmt.executeUpdate();
            }

            System.out.println("[INFO] " + result + " rows upserted successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}