package kr.or.kosa.service.certification;

import java.util.List;

import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.CertificationSummaryDto;

public class certificationService {

    private CertificationDao certificationDao = new CertificationDao();

    /**
     * 현재 연도의 "최신 회차" 기준 요약 목록 조회
     */
    public List<CertificationSummaryDto> getCurrentYearLatestCertifications() {
        return certificationDao.getCurrentYearLatestCertifications();
    }
}