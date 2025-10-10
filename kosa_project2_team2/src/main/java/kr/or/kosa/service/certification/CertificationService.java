package kr.or.kosa.service.certification;

import java.util.List;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

public class CertificationService {
    private final CertificationDao certificationDao;
    private final ApiCertificationDao apiCertificationDao;

    public CertificationService() {
        certificationDao = new CertificationDao();
        apiCertificationDao = new ApiCertificationDao();
    }

    // 자격증 목록 조회 (DB 우선, DB 비었을 경우 API fallback)
    public List<Certification> getCertifications() throws Exception {
        // DB에서 먼저 조회
        List<Certification> list = certificationDao.getAllCertifications();

        // DB가 비어 있으면 API에서 불러오기
        if (list == null || list.isEmpty()) {
            System.out.println("[INFO] DB empty — fetching from API...");

            // API 호출
            List<Certification> apiList = apiCertificationDao.loadCertifications();

            // DB에 저장
            if (apiList != null && !apiList.isEmpty()) {
                int result = certificationDao.upsertCertifications(apiList);
                System.out.println("[INFO] API data upsert complete (" + result + " rows)");
            } else {
                System.out.println("[WARN] API returned no data.");
            }

            // DB에서 다시 읽기
            list = certificationDao.getAllCertifications();
        }

        return list;
    }
    
    
    //강제 동기화 (API → DB) 데이터를 최신 상태로 유지하기 위한 수동 업데이트 기능
    public int syncFromApi() {
        try {
            List<Certification> apiList = apiCertificationDao.loadCertifications();
            if (apiList != null && !apiList.isEmpty()) {
                int result = certificationDao.upsertCertifications(apiList);
                System.out.println("[Sync] API 동기화 완료 (" + result + "건 반영)");
                return result;
            } else {
                System.out.println("[Sync] API 데이터가 비어 있습니다.");
            }
        } catch (Exception e) {
            System.err.println("[Sync] API 동기화 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
