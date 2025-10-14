package kr.or.kosa.dto;

// chartDto를 가공한 이후 반환용 Dto
public class CertificationChartRowDto {
	private int year;
    private int implSeq;
    private String examGb;     // 필기 / 실기
    private int applicants;
    private int passedCnt;
    private double passRate;  
    
    public CertificationChartRowDto() {}

    public CertificationChartRowDto(int year, int implSeq, String examGb,
                                    int applicants, int passedCnt, double passRate) {
        this.year = year;
        this.implSeq = implSeq;
        this.examGb = examGb;
        this.applicants = applicants;
        this.passedCnt = passedCnt;
        this.passRate = passRate;
    }

    // Getter / Setter
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

    public String getExamGb() {
        return examGb;
    }
    public void setExamGb(String examGb) {
        this.examGb = examGb;
    }

    public int getApplicants() {
        return applicants;
    }
    public void setApplicants(int applicants) {
        this.applicants = applicants;
    }

    public int getPassedCnt() {
        return passedCnt;
    }
    public void setPassedCnt(int passedCnt) {
        this.passedCnt = passedCnt;
    }

    public double getPassRate() {
        return passRate;
    }
    public void setPassRate(double passRate) {
        this.passRate = passRate;
    }
}
