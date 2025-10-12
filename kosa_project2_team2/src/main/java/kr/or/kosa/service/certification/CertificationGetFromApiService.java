package kr.or.kosa.service.certification;

import java.util.List;
import kr.or.kosa.dao.ApiCertificationDao;
import kr.or.kosa.dto.Certification;

/** [외부 API에서 자격증 데이터 조회 (DB 저장 X)]
 *
 * ✔ 책임 (SRP)
 *  - 외부 API를 호출하여 자격증 데이터를 가져온다.
 *  - DB에는 저장하지 않고, 순수하게 API 응답만 반환한다.
 *
 * ✔ 사용 예
 *  - 데이터 구조 미리보기
 *  - 동기화 전에 API 데이터가 유효한지 확인
 *  - 관리자 페이지에서 테스트용 출력
 *
 * ✔ 예외 처리
 *  - 이 메서드는 Exception을 던진다.
 *  - 실제 예외 처리와 응답(JSON or JSP)은 Action에서 처리한다.
 */
public class CertificationGetFromApiService {

    private final ApiCertificationDao apiDao;

    public CertificationGetFromApiService() {
        this.apiDao = new ApiCertificationDao();
    }

    /**
     * 외부 API로부터 자격증 목록을 조회한다.
     *
     * @return List<Certification> (API 응답)
     * @throws Exception API 호출 실패 시
     */
    public List<Certification> getFromApi() throws Exception {
        return apiDao.loadCertifications();
    }
}
