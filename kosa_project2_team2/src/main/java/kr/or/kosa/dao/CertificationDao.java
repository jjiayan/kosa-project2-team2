package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.CertificationSummaryDto;
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
}
