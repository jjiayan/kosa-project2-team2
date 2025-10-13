package kr.or.kosa.dto;

import java.io.Serializable;

/**
 * 자격증 시험 통계 정보 (CERTIFICATION_STATS)
 * FK → CERTIFICATION_MASTER(jmcd, year, implSeq)
 */
public class CertificationStatsDto implements Serializable {
    private int jmcd;
    private int year;
    private int implSeq;
    private String examGb;      // 필기/실기 구분
    private Integer applicants; // 응시자수
    private Integer passedCnt;  // 합격자수
    private Integer failedCnt;  // 불합격자수
    private Double passRate;    // 합격률

    public CertificationStatsDto() {}

    public CertificationStatsDto(int jmcd, int year, int implSeq, String examGb,
                                 Integer applicants, Integer passedCnt, Integer failedCnt, Double passRate) {
        this.jmcd = jmcd;
        this.year = year;
        this.implSeq = implSeq;
        this.examGb = examGb;
        this.applicants = applicants;
        this.passedCnt = passedCnt;
        this.failedCnt = failedCnt;
        this.passRate = passRate;
    }

    // Getter / Setter
    public int getJmcd() { return jmcd; }
    public void setJmcd(int jmcd) { this.jmcd = jmcd; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getImplSeq() { return implSeq; }
    public void setImplSeq(int implSeq) { this.implSeq = implSeq; }

    public String getExamGb() { return examGb; }
    public void setExamGb(String examGb) { this.examGb = examGb; }

    public Integer getApplicants() { return applicants; }
    public void setApplicants(Integer applicants) { this.applicants = applicants; }

    public Integer getPassedCnt() { return passedCnt; }
    public void setPassedCnt(Integer passedCnt) { this.passedCnt = passedCnt; }

    public Integer getFailedCnt() { return failedCnt; }
    public void setFailedCnt(Integer failedCnt) { this.failedCnt = failedCnt; }

    public Double getPassRate() { return passRate; }
    public void setPassRate(Double passRate) { this.passRate = passRate; }
}
