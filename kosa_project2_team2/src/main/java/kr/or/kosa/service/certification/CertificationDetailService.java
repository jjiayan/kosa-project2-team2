package kr.or.kosa.service.certification;

import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

/** [자격증 상세 조회]
 *
 * ✔ 책임 (SRP)
 *  - 자격증 ID를 이용하여 DB에서 단일 자격증 정보를 조회한다.
 *
 * ✔ 예외 처리
 *  - 이 메서드는 Exception을 그대로 던진다.
 *  - 실제 try-catch, 에러 화면 처리 등은 Action에서 담당한다.
 *
 * ✔ 확장 가능성
 *  - 추후 상세 조회 시 조회수 증가 등의 비즈니스 로직을 추가할 수 있다.
 */
public class CertificationDetailService {

    private final CertificationDao certificationDao;

    public CertificationDetailService() {
        this.certificationDao = new CertificationDao();
    }

    /**
     * 자격증 상세 정보 조회
     *
     * @param id 자격증 식별자 (PK)
     * @return Certification 객체 (없을 시 null)
     * @throws Exception DB 조회 실패 시
     */
    public Certification getCertificationById(int id) throws Exception {
        return certificationDao.getCertificationById(id);
    }
}
