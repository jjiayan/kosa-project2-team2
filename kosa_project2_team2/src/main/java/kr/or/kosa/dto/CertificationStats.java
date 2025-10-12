package kr.or.kosa.dto;

public class CertificationStats {
    private int jmcd;
    private int year;
    private int implSeq;
    private String examGb; // 필기, 실기
    private int applicants;
    private int passedCnt;
    private int failedCnt;
    private double passRate;

    public CertificationStats() {}

    // Getter / Setter
    public int getJmcd() { return jmcd; }
    public void setJmcd(int jmcd) { this.jmcd = jmcd; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getImplSeq() { return implSeq; }
    public void setImplSeq(int implSeq) { this.implSeq = implSeq; }

    public String getExamGb() { return examGb; }
    public void setExamGb(String examGb) { this.examGb = examGb; }

    public int getApplicants() { return applicants; }
    public void setApplicants(int applicants) { this.applicants = applicants; }

    public int getPassedCnt() { return passedCnt; }
    public void setPassedCnt(int passedCnt) { this.passedCnt = passedCnt; }

    public int getFailedCnt() { return failedCnt; }
    public void setFailedCnt(int failedCnt) { this.failedCnt = failedCnt; }

    public double getPassRate() { return passRate; }
    public void setPassRate(double passRate) { this.passRate = passRate; }
}
