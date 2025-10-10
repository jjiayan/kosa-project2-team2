package kr.or.kosa.service.certification;

import java.util.List;

import com.google.gson.JsonArray;

import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

public class CertificationService {
    private CertificationDao certificationDao;
    private ApiCertificationDao apiCertificationDao;

    public CertificationService() {
        certificationDao = new CertificationDao();
        apiCertificationDao = new ApiCertificationDao();
    }

    /**
     * 자격증 목록 조회 (DB 우선, DB 비었을 경우 API fallback)
     */
    public List<Certification> getCertifications() throws Exception {
        List<Certification> list = certificationDao.getAllCertifications();

        // ✅ DB가 비어있으면 API에서 불러오기
        if (list == null || list.isEmpty()) {
            System.out.println("[INFO] DB empty — fetching from API...");

            // API 호출 (JsonArray 형태로 받음)
            JsonArray jsonArray = apiCertificationDao.fetchCertifications();

            // DB에 업서트
            certificationDao.upsertCertifications(jsonArray);

            // 다시 DB에서 읽기
            list = certificationDao.getAllCertifications();
        }

        return list;
    }
}
