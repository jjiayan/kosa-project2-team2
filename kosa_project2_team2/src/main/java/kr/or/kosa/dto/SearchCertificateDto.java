package kr.or.kosa.dto;

import lombok.Builder;
import lombok.Getter;


import java.util.Map;

@Builder
@Getter
public class SearchCertificateDto {
    private int jmcd;
    private int implseq;
    private int year;
    private String jmName;
    private String totalJmName;
    private Map<String, CertificateDateDto> info;

}
