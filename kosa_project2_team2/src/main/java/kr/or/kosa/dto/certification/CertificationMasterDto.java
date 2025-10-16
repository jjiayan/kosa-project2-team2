package kr.or.kosa.dto.certification;

import java.io.Serializable;

/**
 * 기본 자격증 정보 (CERTIFICATION_MASTER)
 * PK: (jmcd, year, implSeq)
 */
public class CertificationMasterDto implements Serializable {
    private int jmcd;         // 종목코드
    private int year;         // 시행년도
    private int implSeq;      // 시행회차
    private String jmName;    // 자격증명
    private String organName; // 시행기관 (nullable)

    // 기본 생성자
    public CertificationMasterDto() {}

    // 전체 생성자
    public CertificationMasterDto(int jmcd, int year, int implSeq, String jmName, String organName) {
        this.jmcd = jmcd;
        this.year = year;
        this.implSeq = implSeq;
        this.jmName = jmName;
        this.organName = organName;
    }

    // Getter / Setter
    public int getJmcd() { return jmcd; }
    public void setJmcd(int jmcd) { this.jmcd = jmcd; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getImplSeq() { return implSeq; }
    public void setImplSeq(int implSeq) { this.implSeq = implSeq; }

    public String getJmName() { return jmName; }
    public void setJmName(String jmName) { this.jmName = jmName; }

    public String getOrganName() { return organName; }
    public void setOrganName(String organName) { this.organName = organName; }

    @Override
    public String toString() {
        return "CertificationMasterDTO [jmcd=" + jmcd + ", year=" + year + ", implSeq=" + implSeq +
               ", jmName=" + jmName + ", organName=" + organName + "]";
    }
}
