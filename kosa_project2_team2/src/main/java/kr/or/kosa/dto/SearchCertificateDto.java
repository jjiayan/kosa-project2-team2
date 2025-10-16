package kr.or.kosa.dto;

import lombok.Builder;
import lombok.Getter;

import java.sql.Date;

@Builder
@Getter
public class SearchCertificateDto {
    private int jmcd;
    private int implseq;
    private int year;
    private String jmName;
    private String totalJmName;

    // DATE 타입 필드들
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
}
