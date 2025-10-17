package kr.or.kosa.dto.certification;

public class CertificationCategoryDto {
    private String grade;  // 기사, 산업기사 등
    private String field;  // IT, 전기전자 등

    public CertificationCategoryDto() {}

    public CertificationCategoryDto(String grade, String field) {
        this.grade = grade;
        this.field = field;
    }

    // getter / setter
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

    @Override
    public String toString() {
        return "CertificationCategoryDto [grade=" + grade + ", field=" + field + "]";
    }
}
