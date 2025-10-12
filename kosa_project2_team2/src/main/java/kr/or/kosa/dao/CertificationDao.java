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
    private static final String API_URL = "http://192.168.2.24:8091/qualifications_api_server/certifications";
    
    /**
     * 전체 자격증 목록 조회 (DB)
     * 컬럼 Alias를 사용하여 camelCase와 매핑
     */
    public List<Certification> getAllCertifications() {
        List<Certification> list = new ArrayList<>();

        String sql =
            "SELECT " +
            "   jmcd, " +
            "   year, " +
            "   impl_seq AS implSeq, " +
            "   jm_name AS jmName, " +
            "   organ_name AS organName " +
            "FROM certification " +
            "ORDER BY jm_name ASC";

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

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 자격증 상세 조회 (PK: jmcd)
    public Certification getCertificationById(int id) {
        Certification cert = null;
        String sql = "SELECT jmcd, year, impl_seq AS implSeq, jm_name AS jmName, organ_name AS organName "
                   + "FROM certification WHERE jmcd = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                cert = new Certification();
                cert.setJmcd(rs.getInt("jmcd"));
                cert.setYear(rs.getInt("year"));
                cert.setImplSeq(rs.getInt("implSeq"));
                cert.setJmName(rs.getString("jmName"));
                cert.setOrganName(rs.getString("organName"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return cert;
    }


    /**
     * API 데이터 upsert (리스트 기반)
     * MERGE INTO 사용
     */
    public int upsertCertifications(List<Certification> list) {
        String sql =
            "MERGE INTO certification c " +
            "USING (SELECT ? AS jmcd, ? AS jm_name, ? AS organ_name, ? AS year, ? AS impl_seq FROM dual) d " +
            "ON (c.jmcd = d.jmcd) " +
            "WHEN MATCHED THEN " +
            "    UPDATE SET c.jm_name = d.jm_name, c.organ_name = d.organ_name, " +
            "               c.year = d.year, c.impl_seq = d.impl_seq, " +
            "               c.last_updated = SYSDATE " +
            "WHEN NOT MATCHED THEN " +
            "    INSERT (jmcd, jm_name, organ_name, year, impl_seq) " +
            "    VALUES (d.jmcd, d.jm_name, d.organ_name, d.year, d.impl_seq)";

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
            for (int r : results) {
                if (r >= 0) count++;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }
    
    
}