package kr.or.kosa.dto;

import java.sql.Date;

/**
 * 자격증 시험 일정 정보 (CERTIFICATION_SCHEDULE)
 * FK → CERTIFICATION_MASTER(jmcd, year, implSeq)
 */
public class CertificationScheduleDto {
    private int jmcd;
    private int year;
    private int implSeq;
    private Date docRegStartDt;
    private Date docRegEndDt;
    private Date docExamStartDt;
    private Date docExamEndDt;
    private Date docExamDt;
    private Date docPassDt;
    private Date pracRegStartDt;
    private Date pracRegEndDt;
    private Date pracExamStartDt;
    private Date pracExamEndDt;
    private Date pracPassDt;
    private int examFee;

    public CertificationScheduleDto() {}

    // Getter / Setter
    public int getJmcd() { return jmcd; }
    public void setJmcd(int jmcd) { this.jmcd = jmcd; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getImplSeq() { return implSeq; }
    public void setImplSeq(int implSeq) { this.implSeq = implSeq; }

    public Date getDocRegStartDt() { return docRegStartDt; }
    public void setDocRegStartDt(Date docRegStartDt) { this.docRegStartDt = docRegStartDt; }

    public Date getDocRegEndDt() { return docRegEndDt; }
    public void setDocRegEndDt(Date docRegEndDt) { this.docRegEndDt = docRegEndDt; }

    public Date getDocExamStartDt() { return docExamStartDt; }
    public void setDocExamStartDt(Date docExamStartDt) { this.docExamStartDt = docExamStartDt; }

    public Date getDocExamEndDt() { return docExamEndDt; }
    public void setDocExamEndDt(Date docExamEndDt) { this.docExamEndDt = docExamEndDt; }
    
    public Date getDocExamDt() { return docExamDt; }
    public void setDocExamDt(Date docExamDt) { this.docExamDt = docExamDt; }

    public Date getDocPassDt() { return docPassDt; }
    public void setDocPassDt(Date docPassDt) { this.docPassDt = docPassDt; }

    public Date getPracRegStartDt() { return pracRegStartDt; }
    public void setPracRegStartDt(Date pracRegStartDt) { this.pracRegStartDt = pracRegStartDt; }

    public Date getPracRegEndDt() { return pracRegEndDt; }
    public void setPracRegEndDt(Date pracRegEndDt) { this.pracRegEndDt = pracRegEndDt; }

    public Date getPracExamStartDt() { return pracExamStartDt; }
    public void setPracExamStartDt(Date pracExamStartDt) { this.pracExamStartDt = pracExamStartDt; }

    public Date getPracExamEndDt() { return pracExamEndDt; }
    public void setPracExamEndDt(Date pracExamEndDt) { this.pracExamEndDt = pracExamEndDt; }

    public Date getPracPassDt() { return pracPassDt; }
    public void setPracPassDt(Date pracPassDt) { this.pracPassDt = pracPassDt; }

    public int getExamFee() { return examFee; }
    public void setExamFee(int examFee) { this.examFee = examFee; }
}
