package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.CertificationSummaryDto;
import kr.or.kosa.dto.CertificationMasterDto;
import kr.or.kosa.dto.CertificationScheduleDto;
import kr.or.kosa.dto.CertificationStatsDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class CertificationDao {

    // 현재 연도 최신 회차 + 통계 + 일정 + 카테고리 JOIN 조회
    public List<CertificationSummaryDto> getCurrentYearLatestCertifications() {
        List<CertificationSummaryDto> list = new ArrayList<>();

        String sql =
            "SELECT " +
            "    m.JMCD, " +
            "    m.JMNAME, " +
            "    c.GRADE, " +
            "    c.FIELD, " +
            "    m.YEAR, " +
            "    m.IMPLSEQ, " +
            "    s_doc.PASSRATE AS docPassRate, " +
            "    s_doc.APPLICANTS AS docApplicants, " +
            "    s_prac.PASSRATE AS pracPassRate, " +
            "    s_prac.APPLICANTS AS pracApplicants, " +
            "    sch.EXAMFEE, " +
            "    m.ORGANNAME " +
            "FROM CERTIFICATION_MASTER m " +
            "JOIN CERTIFICATION_CATEGORY c " +
            "    ON m.JMCD = c.JMCD " +
            "LEFT JOIN CERTIFICATION_SCHEDULE sch " +
            "    ON m.JMCD = sch.JMCD " +
            "   AND m.YEAR = sch.YEAR " +
            "   AND m.IMPLSEQ = sch.IMPLSEQ " +
            "LEFT JOIN CERTIFICATION_STATS s_doc " +
            "    ON m.JMCD = s_doc.JMCD " +
            "   AND m.YEAR = s_doc.YEAR " +
            "   AND m.IMPLSEQ = s_doc.IMPLSEQ " +
            "   AND s_doc.EXAMGB = '필기' " +
            "LEFT JOIN CERTIFICATION_STATS s_prac " +
            "    ON m.JMCD = s_prac.JMCD " +
            "   AND m.YEAR = s_prac.YEAR " +
            "   AND m.IMPLSEQ = s_prac.IMPLSEQ " +
            "   AND s_prac.EXAMGB = '실기' " +
            "WHERE " +
            "    m.YEAR = EXTRACT(YEAR FROM SYSDATE) " +
            "AND (m.JMCD, m.IMPLSEQ) IN ( " +
            "    SELECT JMCD, MAX(IMPLSEQ) " +
            "    FROM CERTIFICATION_MASTER " +
            "    WHERE YEAR = EXTRACT(YEAR FROM SYSDATE) " +
            "    GROUP BY JMCD " +
            ") " +
            "ORDER BY m.JMNAME";

        try (
            Connection conn = ConnectionPoolHelper.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
        ) {

            while (rs.next()) {
                CertificationSummaryDto dto = new CertificationSummaryDto();

                dto.setJmcd(rs.getInt("JMCD"));
                dto.setJmName(rs.getString("JMNAME"));
                dto.setGrade(rs.getString("GRADE"));
                dto.setField(rs.getString("FIELD"));
                dto.setYear(rs.getInt("YEAR"));
                dto.setImplSeq(rs.getInt("IMPLSEQ"));

                // 필기 통계
                dto.setDocPassRate(rs.getBigDecimal("docPassRate"));    // null 가능
                dto.setDocApplicants(rs.getInt("docApplicants"));       // 0 처리 자동

                // 실기 통계
                dto.setPracPassRate(rs.getBigDecimal("pracPassRate"));
                dto.setPracApplicants(rs.getInt("pracApplicants"));

                // 응시료
                dto.setExamFee(rs.getBigDecimal("EXAMFEE"));            // null 가능

                // 시행기관
                dto.setOrganName(rs.getString("ORGANNAME"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
    // 여기서부터는 API 읽어서 저장하는 메소드 3개
    public int upsertMasters(List<CertificationMasterDto> list) throws Exception {
        String sql =
            "MERGE INTO CERTIFICATION_MASTER t "
            + "USING (SELECT ? AS jmcd, ? AS year, ? AS implSeq, ? AS jmName, ? AS organName FROM dual) s "
            + "ON (t.jmcd = s.jmcd AND t.year = s.year AND t.implSeq = s.implSeq) "
            + "WHEN MATCHED THEN "
            + "  UPDATE SET t.jmName = s.jmName, t.organName = s.organName "
            + "WHEN NOT MATCHED THEN "
            + "  INSERT (jmcd, year, implSeq, jmName, organName) "
            + "  VALUES (s.jmcd, s.year, s.implSeq, s.jmName, s.organName)";

        int total = 0;
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (CertificationMasterDto dto : list) {
                ps.setInt(1, dto.getJmcd());
                ps.setInt(2, dto.getYear());
                ps.setInt(3, dto.getImplSeq());
                ps.setString(4, dto.getJmName());
                ps.setString(5, dto.getOrganName());
                total += ps.executeUpdate();
            }
            System.out.printf("[CertificationDao] MASTER %d건 반영 완료%n", total);
        }
        return total;
    }

    public int upsertSchedules(List<CertificationScheduleDto> list) throws Exception {
        String sql =
            "MERGE INTO CERTIFICATION_SCHEDULE t "
            + "USING (SELECT ? AS jmcd, ? AS year, ? AS implSeq, "
            + "              ? AS docRegStartDt, ? AS docRegEndDt, "
            + "              ? AS docExamStartDt, ? AS docExamEndDt, "
            + "              ? AS docExamDt, ? AS docPassDt, "
            + "              ? AS pracRegStartDt, ? AS pracRegEndDt, "
            + "              ? AS pracExamStartDt, ? AS pracExamEndDt, "
            + "              ? AS pracPassDt, ? AS examFee FROM dual) s "
            + "ON (t.jmcd = s.jmcd AND t.year = s.year AND t.implSeq = s.implSeq) "
            + "WHEN MATCHED THEN "
            + "  UPDATE SET "
            + "      t.docRegStartDt = s.docRegStartDt, "
            + "      t.docRegEndDt = s.docRegEndDt, "
            + "      t.docExamStartDt = s.docExamStartDt, "
            + "      t.docExamEndDt = s.docExamEndDt, "
            + "      t.docExamDt = s.docExamDt, "
            + "      t.docPassDt = s.docPassDt, "
            + "      t.pracRegStartDt = s.pracRegStartDt, "
            + "      t.pracRegEndDt = s.pracRegEndDt, "
            + "      t.pracExamStartDt = s.pracExamStartDt, "
            + "      t.pracExamEndDt = s.pracExamEndDt, "
            + "      t.pracPassDt = s.pracPassDt, "
            + "      t.examFee = s.examFee "
            + "WHEN NOT MATCHED THEN "
            + "  INSERT (jmcd, year, implSeq, "
            + "          docRegStartDt, docRegEndDt, docExamStartDt, docExamEndDt, "
            + "          docExamDt, docPassDt, "
            + "          pracRegStartDt, pracRegEndDt, pracExamStartDt, pracExamEndDt, pracPassDt, examFee) "
            + "  VALUES (s.jmcd, s.year, s.implSeq, "
            + "          s.docRegStartDt, s.docRegEndDt, s.docExamStartDt, s.docExamEndDt, "
            + "          s.docExamDt, s.docPassDt, "
            + "          s.pracRegStartDt, s.pracRegEndDt, s.pracExamStartDt, s.pracExamEndDt, s.pracPassDt, s.examFee)";

        int total = 0;
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (CertificationScheduleDto dto : list) {
                ps.setInt(1, dto.getJmcd());
                ps.setInt(2, dto.getYear());
                ps.setInt(3, dto.getImplSeq());
                ps.setDate(4, dto.getDocRegStartDt());
                ps.setDate(5, dto.getDocRegEndDt());
                ps.setDate(6, dto.getDocExamStartDt());
                ps.setDate(7, dto.getDocExamEndDt());
                ps.setDate(8, dto.getDocExamDt());
                ps.setDate(9, dto.getDocPassDt());
                ps.setDate(10, dto.getPracRegStartDt());
                ps.setDate(11, dto.getPracRegEndDt());
                ps.setDate(12, dto.getPracExamStartDt());
                ps.setDate(13, dto.getPracExamEndDt());
                ps.setDate(14, dto.getPracPassDt());
                ps.setInt(15, dto.getExamFee());
                total += ps.executeUpdate();
            }
            System.out.printf("[CertificationDao] SCHEDULE %d건 반영 완료%n", total);
        }
        return total;
    }
    
    public int upsertStats(List<CertificationStatsDto> list) throws Exception {
        String sql =
            "MERGE INTO CERTIFICATION_STATS t "
            + "USING (SELECT ? AS jmcd, ? AS year, ? AS implSeq, ? AS examGb, "
            + "              ? AS applicants, ? AS passedCnt, ? AS failedCnt, ? AS passRate FROM dual) s "
            + "ON (t.jmcd = s.jmcd AND t.year = s.year AND t.implSeq = s.implSeq AND t.examGb = s.examGb) "
            + "WHEN MATCHED THEN "
            + "  UPDATE SET t.applicants = s.applicants, "
            + "             t.passedCnt = s.passedCnt, "
            + "             t.failedCnt = s.failedCnt, "
            + "             t.passRate = s.passRate "
            + "WHEN NOT MATCHED THEN "
            + "  INSERT (jmcd, year, implSeq, examGb, applicants, passedCnt, failedCnt, passRate) "
            + "  VALUES (s.jmcd, s.year, s.implSeq, s.examGb, s.applicants, s.passedCnt, s.failedCnt, s.passRate)";

        int total = 0;
        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (CertificationStatsDto dto : list) {
                ps.setInt(1, dto.getJmcd());
                ps.setInt(2, dto.getYear());
                ps.setInt(3, dto.getImplSeq());
                ps.setString(4, dto.getExamGb());
                ps.setInt(5, dto.getApplicants());
                ps.setInt(6, dto.getPassedCnt());
                ps.setInt(7, dto.getFailedCnt());
                ps.setDouble(8, dto.getPassRate());
                total += ps.executeUpdate();
            }
            System.out.printf("[CertificationDao] STATS %d건 반영 완료%n", total);
        }
        return total;
    }


    public CertificationSummaryDto getCertificationDetail(int jmcd, int year, int implSeq) {
        CertificationSummaryDto dto = null;

        String sql =
            "SELECT m.JMCD, m.JMNAME, c.GRADE, c.FIELD, "
          + "       m.YEAR, m.IMPLSEQ, m.ORGANNAME, "
          + "       s_doc.PASSRATE AS docPassRate, s_doc.APPLICANTS AS docApplicants, "
          + "       s_prac.PASSRATE AS pracPassRate, s_prac.APPLICANTS AS pracApplicants, "
          + "       sch.EXAMFEE "
          + "FROM CERTIFICATION_MASTER m "
          + "JOIN CERTIFICATION_CATEGORY c ON m.JMCD = c.JMCD "
          + "LEFT JOIN CERTIFICATION_SCHEDULE sch "
          + "  ON m.JMCD = sch.JMCD AND m.YEAR = sch.YEAR AND m.IMPLSEQ = sch.IMPLSEQ "
          + "LEFT JOIN CERTIFICATION_STATS s_doc "
          + "  ON m.JMCD = s_doc.JMCD AND m.YEAR = s_doc.YEAR AND m.IMPLSEQ = s_doc.IMPLSEQ "
          + "  AND s_doc.EXAMGB = '필기' "
          + "LEFT JOIN CERTIFICATION_STATS s_prac "
          + "  ON m.JMCD = s_prac.JMCD AND m.YEAR = s_prac.YEAR AND m.IMPLSEQ = s_prac.IMPLSEQ "
          + "  AND s_prac.EXAMGB = '실기' "
          + "WHERE m.JMCD = ? AND m.YEAR = ? AND m.IMPLSEQ = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, jmcd);
            ps.setInt(2, year);
            ps.setInt(3, implSeq);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = new CertificationSummaryDto();
                    dto.setJmcd(rs.getInt("JMCD"));
                    dto.setJmName(rs.getString("JMNAME"));
                    dto.setGrade(rs.getString("GRADE"));
                    dto.setField(rs.getString("FIELD"));
                    dto.setYear(rs.getInt("YEAR"));
                    dto.setImplSeq(rs.getInt("IMPLSEQ"));
                    dto.setOrganName(rs.getString("ORGANNAME"));
                    dto.setDocPassRate(rs.getBigDecimal("docPassRate"));
                    dto.setDocApplicants(rs.getInt("docApplicants"));
                    dto.setPracPassRate(rs.getBigDecimal("pracPassRate"));
                    dto.setPracApplicants(rs.getInt("pracApplicants"));
                    dto.setExamFee(rs.getBigDecimal("EXAMFEE"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }
}
