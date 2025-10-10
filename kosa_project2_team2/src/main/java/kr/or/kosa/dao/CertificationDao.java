package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.Certification;
import kr.or.kosa.utils.ConnectionPoolHelper;

/**
 * DB에 자격증 정보를 CRUD하는 DAO
 * - API에서 받아온 데이터를 DB에 upsert(삽입 또는 갱신)
 * - 로컬 DB 조회용
 */
public class CertificationDao {

    public List<Certification> getAllCertifications() {
        List<Certification> list = new ArrayList<>();
        String sql = "SELECT jmcd, jmName, organName, year, implSeq FROM certification";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Certification c = new Certification();
                c.setJmcd(rs.getInt("jmcd"));
                c.setJmName(rs.getString("jmName"));
                c.setOrganName(rs.getString("organName"));
                c.setYear(rs.getInt("year"));
                c.setImplSeq(rs.getInt("implSeq"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}