package kr.or.kosa.dto;


public class CertificationSummaryDto {

    // 기본 정보
    private int jmcd;               // 종목코드
    private String jmName;          // 자격증명
    private String grade;           // 등급 (기사 / 산업기사 / 기능사 / …)
    private String field;           // 분야 (정보처리 / 보안 / 데이터 / …)

    // 최신 회차 정보
    private int year;               // 연도 (현재년도)
    private int implSeq;            // 회차

    // 필기 통계
    private Double docPassRate; // 필기 합격률 (0.00~100.00)
    private int docApplicants;      // 필기 응시자 수

    // 실기 통계
    private Double pracPassRate;// 실기 합격률
    private int pracApplicants;     // 실기 응시자 수

    // 시험 비용
    private int examFee;     // 시험 응시 총비용 (필기+실기 합산 or 한 번 기준)
    
    // 시행기관
    private String organName;

    // ===== Getter / Setter =====
    public int getJmcd() {
        return jmcd;
    }
    public void setJmcd(int jmcd) {
        this.jmcd = jmcd;
    }
    public String getJmName() {
        return jmName;
    }
    public void setJmName(String jmName) {
        this.jmName = jmName;
    }
    public String getGrade() {
        return grade;
    }
    public void setGrade(String grade) {
        this.grade = grade;
    }
    public String getField() {
        return field;
    }
    public void setField(String field) {
        this.field = field;
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
    public Double getDocPassRate() {
        return docPassRate;
    }
    public void setDocPassRate(Double docPassRate) {
        this.docPassRate = docPassRate;
    }
    public int getDocApplicants() {
        return docApplicants;
    }
    public void setDocApplicants(int docApplicants) {
        this.docApplicants = docApplicants;
    }
    public Double getPracPassRate() {
        return pracPassRate;
    }
    public void setPracPassRate(Double pracPassRate) {
        this.pracPassRate = pracPassRate;
    }
    public int getPracApplicants() {
        return pracApplicants;
    }
    public void setPracApplicants(int pracApplicants) {
        this.pracApplicants = pracApplicants;
    }
    public int getExamFee() {
        return examFee;
    }
    public void setExamFee(int examFee) {
        this.examFee = examFee;
    }
    public String getOrganName() {
        return organName;
    }
    public void setOrganName(String organName) {
        this.organName = organName;
    }
}
