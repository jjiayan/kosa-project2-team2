package kr.or.kosa.service.certification;

import java.util.List;

import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

/**
 * - 외부 API → DB 동기화 (수동/스케줄러/Init 등에서 호출용)
 * - 일반 Java 코드에서도 사용 가능 (Action에 묶이지 않음)
 */
public class CertificationSyncService {

    private final ApiCertificationDao apiDao;
    private final CertificationDao certificationDao;

    public CertificationSyncService() {
        this.apiDao = new ApiCertificationDao();
        this.certificationDao = new CertificationDao();
    }

    /**
     * 외부 API 데이터를 DB에 동기화 (Upsert)
     * @return int (처리된 row 수)
     * @throws Exception
     */
    public int syncFromApi() throws Exception {
        // API에서 데이터 조회
        List<Certification> apiList = apiDao.loadCertifications();

        if (apiList == null || apiList.isEmpty()) {
            System.out.println("[SyncService] API 데이터가 없습니다.");
            return 0;
        }

        // DB에 upsert 처리
        int result = certificationDao.upsertCertifications(apiList);

        System.out.println("[SyncService] 동기화 완료 (" + result + "건 반영)");
        return result;
    }
}
