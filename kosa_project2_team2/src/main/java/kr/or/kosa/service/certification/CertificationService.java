package kr.or.kosa.service.certification;

import java.util.List;

import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.certification.CertificationMasterDto;
import kr.or.kosa.dto.certification.CertificationScheduleDto;
import kr.or.kosa.dto.certification.CertificationStatsDto;
import kr.or.kosa.dto.certification.CertificationSummaryDto;


// 자격증 API 연동 및 DB 반영을 관리하는 서비스 클래스
public class CertificationService {

    private final ApiCertificationDao apiDao = new ApiCertificationDao();
    private final CertificationDao certDao = new CertificationDao();

    // 외부 API → DB 동기화
    public void syncAll() {
        try {

            List<CertificationMasterDto> masters = apiDao.loadCertifications();
            if (masters != null && !masters.isEmpty()) {
                int masterCount = certDao.upsertMasters(masters);
                System.out.printf("[CertificationService] MASTER 반영 완료: %d건%n", masterCount);
            }

            List<CertificationScheduleDto> schedules = apiDao.loadSchedules();
            if (schedules != null && !schedules.isEmpty()) {
                int scheduleCount = certDao.upsertSchedules(schedules);
                System.out.printf("[CertificationService] SCHEDULE 반영 완료: %d건%n", scheduleCount);
            }

            List<CertificationStatsDto> stats = apiDao.loadStats();
            if (stats != null && !stats.isEmpty()) {
                int statsCount = certDao.upsertStats(stats);
                System.out.printf("[CertificationService] STATS 반영 완료: %d건%n", statsCount);
            }

            System.out.println("[CertificationService] 전체 동기화 완료");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[CertificationService] 동기화 중 오류 발생: " + e.getMessage());
        }
    }


    // 올해 기준 최신순 자격증 목록 조회
    public List<CertificationSummaryDto> getCurrentYearList() {
        return certDao.getCurrentYearLatestCertifications();
    }
}