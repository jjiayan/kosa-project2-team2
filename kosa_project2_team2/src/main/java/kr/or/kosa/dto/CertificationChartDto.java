package kr.or.kosa.dto;

public class CertificationChartDto {

    private int jmcd;           // 종목코드
    private int year;           // 연도
    private int implSeq;        // 회차

    private Double docRate;         // 필기 합격률 (%)
    private Integer docApplicants;  // 필기 응시자 수

    private Double pracRate;        // 실기 합격률 (%)
    private Integer pracApplicants; // 실기 응시자 수

    // Getter / Setter
    public int getJmcd() {
        return jmcd;
    }
    public void setJmcd(int jmcd) {
        this.jmcd = jmcd;
    }
    public int getYear() {
        return year;
    }
    public void setYear(int year) {
        this.year = year;
    }
    public int getImplSeq() {
        return implSeq;
    }
    public void setImplSeq(int implSeq) {
        this.implSeq = implSeq;
    }
    public Double getDocRate() {
        return docRate;
    }
    public void setDocRate(Double docRate) {
        this.docRate = docRate;
    }
    public Integer getDocApplicants() {
        return docApplicants;
    }
    public void setDocApplicants(Integer docApplicants) {
        this.docApplicants = docApplicants;
    }
    public Double getPracRate() {
        return pracRate;
    }
    public void setPracRate(Double pracRate) {
        this.pracRate = pracRate;
    }
    public Integer getPracApplicants() {
        return pracApplicants;
    }
    public void setPracApplicants(Integer pracApplicants) {
        this.pracApplicants = pracApplicants;
    }
}
