package kr.or.kosa.dto;

/**
 * 자격증 시험 일정 정보 (CERTIFICATION_SCHEDULE)
 * FK → CERTIFICATION_MASTER(jmcd, year, implSeq)
 */
public class CertificationScheduleDto {
    private int jmcd;
    private int year;
    private int implSeq;

    private String docRegStartDt;
    private String docRegEndDt;
    private String docExamStartDt;
    private String docExamEndDt;
    private String docPassDt;
    private String pracRegStartDt;
    private String pracRegEndDt;
    private String pracExamStartDt;
    private String pracExamEndDt;
    private String pracPassDt;
    private int examFee;

    public CertificationScheduleDto() {}

    // Getter / Setter
    public int getJmcd() { return jmcd; }
    public void setJmcd(int jmcd) { this.jmcd = jmcd; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getImplSeq() { return implSeq; }
    public void setImplSeq(int implSeq) { this.implSeq = implSeq; }

    public String getDocRegStartDt() { return docRegStartDt; }
    public void setDocRegStartDt(String docRegStartDt) { this.docRegStartDt = docRegStartDt; }

    public String getDocRegEndDt() { return docRegEndDt; }
    public void setDocRegEndDt(String docRegEndDt) { this.docRegEndDt = docRegEndDt; }

    public String getDocExamStartDt() { return docExamStartDt; }
    public void setDocExamStartDt(String docExamStartDt) { this.docExamStartDt = docExamStartDt; }

    public String getDocExamEndDt() { return docExamEndDt; }
    public void setDocExamEndDt(String docExamEndDt) { this.docExamEndDt = docExamEndDt; }

    public String getDocPassDt() { return docPassDt; }
    public void setDocPassDt(String docPassDt) { this.docPassDt = docPassDt; }

    public String getPracRegStartDt() { return pracRegStartDt; }
    public void setPracRegStartDt(String pracRegStartDt) { this.pracRegStartDt = pracRegStartDt; }

    public String getPracRegEndDt() { return pracRegEndDt; }
    public void setPracRegEndDt(String pracRegEndDt) { this.pracRegEndDt = pracRegEndDt; }

    public String getPracExamStartDt() { return pracExamStartDt; }
    public void setPracExamStartDt(String pracExamStartDt) { this.pracExamStartDt = pracExamStartDt; }

    public String getPracExamEndDt() { return pracExamEndDt; }
    public void setPracExamEndDt(String pracExamEndDt) { this.pracExamEndDt = pracExamEndDt; }

    public String getPracPassDt() { return pracPassDt; }
    public void setPracPassDt(String pracPassDt) { this.pracPassDt = pracPassDt; }

    public int getExamFee() { return examFee; }
    public void setExamFee(int examFee) { this.examFee = examFee; }
}
