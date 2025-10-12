package kr.or.kosa.dto;

/**
 * 자격증 기본 정보 DTO
 * API 서버의 certifications.json 구조와 동일해야 함
 */
public class Certification {
    private int jmcd;           // 종목코드
    private int year;           // 연도
    private int implSeq;        // 시행차수
    private String jmName;      // 자격증명
    private String organName;   // 주관기관명

    // ✅ 기본 생성자
    public Certification() {}

    // ✅ 모든 필드를 받는 생성자
    public Certification(int jmcd, int year, int implSeq, String jmName, String organName) {
        this.jmcd = jmcd;
        this.year = year;
        this.implSeq = implSeq;
        this.jmName = jmName;
        this.organName = organName;
    }

    // ✅ Getter / Setter
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

    public String getJmName() {
        return jmName;
    }

    public void setJmName(String jmName) {
        this.jmName = jmName;
    }

    public String getOrganName() {
        return organName;
    }

    public void setOrganName(String organName) {
        this.organName = organName;
    }

    @Override
    public String toString() {
        return "Certification{" +
                "jmcd=" + jmcd +
                ", year=" + year +
                ", implSeq=" + implSeq +
                ", jmName='" + jmName + '\'' +
                ", organName='" + organName + '\'' +
                '}';
    }
}