package kr.or.kosa.service.certification;

import java.util.List;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

/** [외부 API → DB 동기화]
 *
 * ✔ 책임 (SRP)
 *  - 외부 API에서 자격증 데이터를 가져온다.
 *  - 가져온 데이터를 DB에 삽입 혹은 업데이트(Upsert)한다.
 *  - 몇 건이 반영되었는지를 반환한다.
 *
 * ✔ 사용 예
 *  - 관리자 수동 동기화 기능 (버튼 클릭 시)
 *  - 정기 스케줄러에 의한 자동 동기화
 *  - 초기 데이터 세팅 (Temp 실행 클래스에서 사용 가능)
 *
 * ✔ 예외 처리
 *  - 이 메서드는 Exception을 그대로 던진다.
 *  - 실제 예외 처리 및 사용자 응답 처리는 Action에서 담당한다.
 */
public class CertificationSyncService {

    private final ApiCertificationDao apiDao;
    private final CertificationDao certificationDao;

    public CertificationSyncService() {
        this.apiDao = new ApiCertificationDao();
        this.certificationDao = new CertificationDao();
    }

    /**
     * 외부 API로부터 데이터를 가져와 DB에 동기화한다.
     *
     * @return int : DB에 삽입 또는 갱신된 레코드 수
     * @throws Exception API 호출 또는 DB 처리 실패 시
     */
    public int syncFromApi() throws Exception {
        // 1) 외부 API에서 데이터 가져오기
        List<Certification> apiList = apiDao.loadCertifications();

        // 2) API 응답이 비어있다면 동기화할 필요 없음
        if (apiList == null || apiList.isEmpty()) {
            return 0;
        }

        // 3) DB에 upsert 처리 (삽입 또는 업데이트)
        return certificationDao.upsertCertifications(apiList);
    }
}
