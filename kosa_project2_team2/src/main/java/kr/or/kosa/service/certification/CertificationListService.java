package kr.or.kosa.service.certification;

import java.util.List;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

/** [자격증 전체 목록 조회]
 * 
 * ✔ 책임(SRP)
 *  - DAO를 호출하여 전체 자격증 리스트를 반환한다.
 *  - 추가적인 비즈니스 로직은 포함하지 않는다.
 * 
 * ✔ 예외 처리
 *  - 이 메서드는 Exception을 던진다.
 *  - 실제 예외 처리(try-catch)는 Action(컨트롤러)에서 수행한다.
 * 
 * ✔ 확장성
 *  - 추후 페이징 / 검색 / 정렬 등으로 확장할 수 있다.
 */
public class CertificationListService {

    private final CertificationDao certificationDao;

    public CertificationListService() {
        this.certificationDao = new CertificationDao();
    }

    /**
     * 전체 자격증 목록 조회
     * @return List<Certification>
     * @throws Exception DB 조회 실패 시
     */
    public List<Certification> getCertificationList() throws Exception {
        return certificationDao.getAllCertifications();
    }
}
