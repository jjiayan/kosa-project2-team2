package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import kr.or.kosa.dto.Certification;
import kr.or.kosa.utils.ConnectionPoolHelper;

/**
 * DB에 자격증 정보를 CRUD하는 DAO
 * - API에서 받아온 데이터를 DB에 upsert(삽입 또는 갱신)
 * - 로컬 DB 조회용
 */
public class CertificationDao {

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