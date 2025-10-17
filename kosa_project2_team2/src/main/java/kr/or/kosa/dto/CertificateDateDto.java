package kr.or.kosa.dto;



import java.util.Date;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class CertificateDateDto {
	private Date docRegStartDt; // 원서접수 시작일
    private Date docRegEndDt; // 원서접수 종료일
    private Date docExamStartDt; // 필기접수 시작일
    private Date docExamEndDt; // 필기접수 종료일
    private Date docExamDt; // 필기시험일
    private Date docPassDt; // 필기시험 합격자 발표일
    private Date pracRegStartDt; // 실기접수 시작일
    private Date pracRegEndDt; // 실기접수 종료일
    private Date pracExamStartDt; // 실기시험 시작일
    private Date pracExamEndDt; // 실기시험 종료일
    private Date pracPassDt; // 실기시험 합격자 발표일

}
