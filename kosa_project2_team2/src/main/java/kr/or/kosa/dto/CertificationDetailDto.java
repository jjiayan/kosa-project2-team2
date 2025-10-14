package kr.or.kosa.dto;

import java.sql.Date;
import java.util.List;

public class CertificationDetailDto {

    // ===== 기본 정보 =====
    private int jmcd;           // 종목코드
    private String jmName;      // 자격증명
    private String grade;       // 등급
    private String field;       // 분야
    private String organName;   // 시행기관

    // ===== 선택된 회차 정보 =====
    private int year;           // 연도
    private int implSeq;        // 회차

    // ===== 필기 일정 =====
    private Date docRegStartDt;     // 원서접수 시작
    private Date docRegEndDt;       // 원서접수 종료
    private Date docExamStartDt;    // 시험 시작 (기간일 경우)
    private Date docExamEndDt;      // 시험 종료 (기간일 경우)
    private Date docExamDt;         // 시험일 (단일 날짜일 경우)
    private Date docPassDt;         // 합격발표일

    // ===== 실기 일정 =====
    private Date pracRegStartDt;     // 원서접수 시작
    private Date pracRegEndDt;       // 원서접수 종료
    private Date pracExamStartDt;    // 시험 시작
    private Date pracExamEndDt;      // 시험 종료
    private Date pracPassDt;         // 합격발표일

    // ===== 통계 정보 =====
    private Double docPassRate;      // 필기 합격률
    private int docApplicants;       // 필기 응시자 수
    private Double pracPassRate;     // 실기 합격률
    private int pracApplicants;      // 실기 응시자 수

    // ===== 전체 회차 목록 (탭용) =====
    private List<CertificationDetailDto> rounds;
    
    // 상세 페이지 Chart
    private List<CertificationChartDto> chartList;   // 회차별 통계
    private Double avgDocRate;                       // 평균 필기 합격률
    private Double avgPracRate;                      // 평균 실기 합격률
    private Integer totalApplicants;                 // 총 응시자 수


    // Getter / Setter
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
    public String getOrganName() {
        return organName;
    }
    public void setOrganName(String organName) {
        this.organName = organName;
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

    public Date getDocRegStartDt() {
        return docRegStartDt;
    }
    public void setDocRegStartDt(Date docRegStartDt) {
        this.docRegStartDt = docRegStartDt;
    }
    public Date getDocRegEndDt() {
        return docRegEndDt;
    }
    public void setDocRegEndDt(Date docRegEndDt) {
        this.docRegEndDt = docRegEndDt;
    }
    public Date getDocExamStartDt() {
        return docExamStartDt;
    }
    public void setDocExamStartDt(Date docExamStartDt) {
        this.docExamStartDt = docExamStartDt;
    }
    public Date getDocExamEndDt() {
        return docExamEndDt;
    }
    public void setDocExamEndDt(Date docExamEndDt) {
        this.docExamEndDt = docExamEndDt;
    }
    public Date getDocExamDt() {
        return docExamDt;
    }
    public void setDocExamDt(Date docExamDt) {
        this.docExamDt = docExamDt;
    }
    public Date getDocPassDt() {
        return docPassDt;
    }
    public void setDocPassDt(Date docPassDt) {
        this.docPassDt = docPassDt;
    }

    public Date getPracRegStartDt() {
        return pracRegStartDt;
    }
    public void setPracRegStartDt(Date pracRegStartDt) {
        this.pracRegStartDt = pracRegStartDt;
    }
    public Date getPracRegEndDt() {
        return pracRegEndDt;
    }
    public void setPracRegEndDt(Date pracRegEndDt) {
        this.pracRegEndDt = pracRegEndDt;
    }
    public Date getPracExamStartDt() {
        return pracExamStartDt;
    }
    public void setPracExamStartDt(Date pracExamStartDt) {
        this.pracExamStartDt = pracExamStartDt;
    }
    public Date getPracExamEndDt() {
        return pracExamEndDt;
    }
    public void setPracExamEndDt(Date pracExamEndDt) {
        this.pracExamEndDt = pracExamEndDt;
    }
    public Date getPracPassDt() {
        return pracPassDt;
    }
    public void setPracPassDt(Date pracPassDt) {
        this.pracPassDt = pracPassDt;
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

    public List<CertificationDetailDto> getRounds() {
        return rounds;
    }
    public void setRounds(List<CertificationDetailDto> rounds) {
        this.rounds = rounds;
    }
    public List<CertificationChartDto> getChartList() {
        return chartList;
    }

    public void setChartList(List<CertificationChartDto> chartList) {
        this.chartList = chartList;
    }

    public Double getAvgDocRate() {
        return avgDocRate;
    }

    public void setAvgDocRate(Double avgDocRate) {
        this.avgDocRate = avgDocRate;
    }

    public Double getAvgPracRate() {
        return avgPracRate;
    }

    public void setAvgPracRate(Double avgPracRate) {
        this.avgPracRate = avgPracRate;
    }

    public Integer getTotalApplicants() {
        return totalApplicants;
    }

    public void setTotalApplicants(Integer totalApplicants) {
        this.totalApplicants = totalApplicants;
    }
}
