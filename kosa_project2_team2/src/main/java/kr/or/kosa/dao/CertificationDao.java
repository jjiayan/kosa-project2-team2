package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.kosa.dto.certification.CertificationChartRowDto;
import kr.or.kosa.dto.certification.CertificationDetailDto;
import kr.or.kosa.dto.certification.CertificationMasterDto;
import kr.or.kosa.dto.certification.CertificationScheduleDto;
import kr.or.kosa.dto.certification.CertificationStatsDto;
import kr.or.kosa.dto.certification.CertificationSummaryDto;
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
                dto.setDocPassRate(rs.getDouble("docPassRate"));    // null 가능
                dto.setDocApplicants(rs.getInt("docApplicants"));       // 0 처리 자동

                // 실기 통계
                dto.setPracPassRate(rs.getDouble("pracPassRate"));
                dto.setPracApplicants(rs.getInt("pracApplicants"));

                // 응시료
                dto.setExamFee(rs.getInt("EXAMFEE"));            // null 가능

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
    
    
    // AJAX 필터 전용 메서드 (+ 페이징)
 // CertificationDao.java

 // 1-1) 목록 조회 (필터 + 페이징)
 // ✅ 클라이언트 페이지네이션(slice)용 전체 필터 조회 메서드
    public List<CertificationSummaryDto> getFilteredCertifications(
            String grade, String field, String keyword) {

        List<CertificationSummaryDto> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append(
            "WITH latest AS ( " +
            "  SELECT jmcd, MAX(implSeq) AS implSeq " +
            "  FROM CERTIFICATION_MASTER " +
            "  WHERE year = EXTRACT(YEAR FROM SYSDATE) " +
            "  GROUP BY jmcd " +
            ") " +
            "SELECT " +
            "  m.JMCD, m.JMNAME, c.GRADE, c.FIELD, m.YEAR, m.IMPLSEQ, " +
            "  s_doc.PASSRATE AS docPassRate, s_doc.APPLICANTS AS docApplicants, " +
            "  s_prac.PASSRATE AS pracPassRate, s_prac.APPLICANTS AS pracApplicants, " +
            "  sch.EXAMFEE, m.ORGANNAME " +
            "FROM CERTIFICATION_MASTER m " +
            "JOIN latest l ON l.jmcd = m.jmcd AND l.implSeq = m.implSeq " +
            "             AND m.year = EXTRACT(YEAR FROM SYSDATE) " +
            "JOIN CERTIFICATION_CATEGORY c ON m.JMCD = c.JMCD " +
            "LEFT JOIN CERTIFICATION_SCHEDULE sch " +
            "  ON m.JMCD = sch.JMCD AND m.YEAR = sch.YEAR AND m.IMPLSEQ = sch.IMPLSEQ " +
            "LEFT JOIN CERTIFICATION_STATS s_doc " +
            "  ON m.JMCD = s_doc.JMCD AND m.YEAR = s_doc.YEAR AND m.IMPLSEQ = s_doc.IMPLSEQ " +
            " AND s_doc.EXAMGB = '필기' " +
            "LEFT JOIN CERTIFICATION_STATS s_prac " +
            "  ON m.JMCD = s_prac.JMCD AND m.YEAR = s_prac.YEAR AND m.IMPLSEQ = s_prac.IMPLSEQ " +
            " AND s_prac.EXAMGB = '실기' " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (grade != null && !grade.isEmpty()) {
            sql.append(" AND c.GRADE = ? ");
            params.add(grade);
        }
        if (field != null && !field.isEmpty()) {
            sql.append(" AND c.FIELD = ? ");
            params.add(field);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND m.JMNAME LIKE '%' || ? || '%' ");
            params.add(keyword);
        }

        sql.append(" ORDER BY m.JMNAME ");

        try (
            Connection conn = ConnectionPoolHelper.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())
        ) {
            int idx = 1;
            for (Object p : params) {
                ps.setObject(idx++, p);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CertificationSummaryDto dto = new CertificationSummaryDto();
                    dto.setJmcd(rs.getInt("JMCD"));
                    dto.setJmName(rs.getString("JMNAME"));
                    dto.setGrade(rs.getString("GRADE"));
                    dto.setField(rs.getString("FIELD"));
                    dto.setYear(rs.getInt("YEAR"));
                    dto.setImplSeq(rs.getInt("IMPLSEQ"));
                    dto.setDocPassRate(rs.getDouble("docPassRate"));
                    dto.setDocApplicants(rs.getInt("docApplicants"));
                    dto.setPracPassRate(rs.getDouble("pracPassRate"));
                    dto.setPracApplicants(rs.getInt("pracApplicants"));
                    dto.setExamFee(rs.getInt("EXAMFEE"));
                    dto.setOrganName(rs.getString("ORGANNAME"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
    // 상세정보 조회
    public CertificationDetailDto getCertificationDetail(int jmcd, int year, int implSeq) {
        CertificationDetailDto dto = null;

        String sql =
            "SELECT m.JMCD, m.JMNAME, c.GRADE, c.FIELD, " +
            "       m.YEAR, m.IMPLSEQ, m.ORGANNAME, " +
            "       sch.DOCREGSTARTDT, sch.DOCREGENDDT, " +
            "       sch.DOCEXAMSTARTDT, sch.DOCEXAMENDDT, sch.DOCEXAMDT, sch.DOCPASSDT, " +
            "       sch.PRACREGSTARTDT, sch.PRACREGENDDT, " +
            "       sch.PRACEXAMSTARTDT, sch.PRACEXAMENDDT, sch.PRACPASSDT, " +
            "       s_doc.PASSRATE AS docPassRate, s_doc.APPLICANTS AS docApplicants, " +
            "       s_prac.PASSRATE AS pracPassRate, s_prac.APPLICANTS AS pracApplicants " +
            "FROM CERTIFICATION_MASTER m " +
            "JOIN CERTIFICATION_CATEGORY c ON m.JMCD = c.JMCD " +
            "LEFT JOIN CERTIFICATION_SCHEDULE sch " +
            "  ON m.JMCD = sch.JMCD AND m.YEAR = sch.YEAR AND m.IMPLSEQ = sch.IMPLSEQ " +
            "LEFT JOIN CERTIFICATION_STATS s_doc " +
            "  ON m.JMCD = s_doc.JMCD AND m.YEAR = s_doc.YEAR AND m.IMPLSEQ = s_doc.IMPLSEQ " +
            "  AND s_doc.EXAMGB = '필기' " +
            "LEFT JOIN CERTIFICATION_STATS s_prac " +
            "  ON m.JMCD = s_prac.JMCD AND m.YEAR = s_prac.YEAR AND m.IMPLSEQ = s_prac.IMPLSEQ " +
            "  AND s_prac.EXAMGB = '실기' " +
            "WHERE m.JMCD = ? AND m.YEAR = ? AND m.IMPLSEQ = ?";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, jmcd);
            pstmt.setInt(2, year);
            pstmt.setInt(3, implSeq);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new CertificationDetailDto();

                    // 기본 정보
                    dto.setJmcd(rs.getInt("JMCD"));
                    dto.setJmName(rs.getString("JMNAME"));
                    dto.setGrade(rs.getString("GRADE"));
                    dto.setField(rs.getString("FIELD"));
                    dto.setOrganName(rs.getString("ORGANNAME"));
                    dto.setYear(rs.getInt("YEAR"));
                    dto.setImplSeq(rs.getInt("IMPLSEQ"));

                    // 필기 일정
                    dto.setDocRegStartDt(rs.getDate("DOCREGSTARTDT"));
                    dto.setDocRegEndDt(rs.getDate("DOCREGENDDT"));
                    dto.setDocExamStartDt(rs.getDate("DOCEXAMSTARTDT"));
                    dto.setDocExamEndDt(rs.getDate("DOCEXAMENDDT"));
                    dto.setDocExamDt(rs.getDate("DOCEXAMDT"));
                    dto.setDocPassDt(rs.getDate("DOCPASSDT"));

                    // 실기 일정
                    dto.setPracRegStartDt(rs.getDate("PRACREGSTARTDT"));
                    dto.setPracRegEndDt(rs.getDate("PRACREGENDDT"));
                    dto.setPracExamStartDt(rs.getDate("PRACEXAMSTARTDT"));
                    dto.setPracExamEndDt(rs.getDate("PRACEXAMENDDT"));
                    dto.setPracPassDt(rs.getDate("PRACPASSDT"));

                    // 통계
                    dto.setDocPassRate(rs.getDouble("docPassRate"));
                    dto.setDocApplicants(rs.getInt("docApplicants"));
                    dto.setPracPassRate(rs.getDouble("pracPassRate"));
                    dto.setPracApplicants(rs.getInt("pracApplicants"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }
    
    // 회차 목록 조회 메소드
    public List<CertificationDetailDto> getRoundsByJmcd(int jmcd) {
        List<CertificationDetailDto> rounds = new ArrayList<>();

        String sql =
            "SELECT YEAR, IMPLSEQ " +
            "FROM CERTIFICATION_MASTER " +
            "WHERE JMCD = ? " +
            "AND YEAR BETWEEN (EXTRACT(YEAR FROM SYSDATE) - 2) AND EXTRACT(YEAR FROM SYSDATE) " +
            "ORDER BY YEAR DESC, IMPLSEQ ASC";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, jmcd);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CertificationDetailDto dto = new CertificationDetailDto();
                    dto.setYear(rs.getInt("YEAR"));
                    dto.setImplSeq(rs.getInt("IMPLSEQ"));
                    rounds.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rounds;
    }
    
    // Controller가 편하게 사용하도록 상세 + 회차 목록을 묶어주는 메서드
    public CertificationDetailDto getDetailWithRounds(int jmcd, int year, int implSeq) {
    	
        // 현재 회차 상세 조회
        CertificationDetailDto detail = getCertificationDetail(jmcd, year, implSeq);
        if (detail == null) return null;

        // 최근 3년치 회차 목록 조회
        List<CertificationDetailDto> rounds = getRoundsByJmcd(jmcd);

        // DTO에 저장
        detail.setRounds(rounds);
        
        return detail;
    }


    public CertificationDetailDto getCurrentYearLatestCertification(int jmcd) {
        CertificationDetailDto dto = null;

        String sql =
            "SELECT jmcd, year, MAX(implSeq) AS latestImplSeq " +
            "FROM CERTIFICATION_MASTER " +
            "WHERE jmcd = ? " +
            "AND year = EXTRACT(YEAR FROM SYSDATE) " +
            "GROUP BY jmcd, year";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, jmcd);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int year = rs.getInt("year");
                    int implSeq = rs.getInt("latestImplSeq");

                    // 최신 회차 상세 정보 + rounds까지 포함
                    dto = getDetailWithRounds(jmcd, year, implSeq);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }


    public List<CertificationChartRowDto> getStatsByJmcd(int jmcd) {
        List<CertificationChartRowDto> list = new ArrayList<>();

        String sql = "SELECT year, implSeq, examGb, applicants, passedCnt, " +
                     "       ROUND((passedCnt / NULLIF(applicants, 0)) * 100, 2) AS passRate " +
                     "FROM CERTIFICATION_STATS " +
                     "WHERE jmcd = ? " +
                     "ORDER BY year DESC, implSeq ASC";

        try (Connection conn = ConnectionPoolHelper.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, jmcd);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CertificationChartRowDto dto = new CertificationChartRowDto();
                    dto.setYear(rs.getInt("year"));
                    dto.setImplSeq(rs.getInt("implSeq"));
                    dto.setExamGb(rs.getString("examGb"));
                    dto.setApplicants(rs.getInt("applicants"));
                    dto.setPassedCnt(rs.getInt("passedCnt"));
                    dto.setPassRate(rs.getDouble("passRate"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public Map<String, Object> getCategories() {
    	System.out.println(">>> [DAO] getCategories() 호출됨"); 
        Map<String, Object> map = new HashMap<>();

        List<String> grades = new ArrayList<>();
        List<String> fields = new ArrayList<>();

        String sql1 =
        	    "SELECT DISTINCT GRADE " +
        	    "FROM CERTIFICATION_CATEGORY " +
        	    "WHERE GRADE IS NOT NULL " +
        	    "  AND TRIM(GRADE) <> '' " +
        	    "ORDER BY GRADE";

        	String sql2 =
        	    "SELECT DISTINCT FIELD " +
        	    "FROM CERTIFICATION_CATEGORY " +
        	    "WHERE FIELD IS NOT NULL " +
        	    "  AND TRIM(FIELD) <> '' " +
        	    "ORDER BY FIELD";

        try (Connection conn = ConnectionPoolHelper.getConnection()) {

            // === 1) GRADE 조회
            try (PreparedStatement ps = conn.prepareStatement(sql1);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    grades.add(rs.getString("GRADE"));
                }
            }

            // === 2) FIELD 조회
            try (PreparedStatement ps = conn.prepareStatement(sql2);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    fields.add(rs.getString("FIELD"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        map.put("grades", grades);
        map.put("fields", fields);

        return map;
    }


}