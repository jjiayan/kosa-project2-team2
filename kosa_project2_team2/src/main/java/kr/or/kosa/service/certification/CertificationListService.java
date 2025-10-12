package kr.or.kosa.service.certification;

import java.util.List;

import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.Certification;

public class CertificationListService {
    public List<Certification> getCertificationList() throws Exception {
        CertificationDao dao = new CertificationDao();
        return dao.getAllCertifications();
    }
}
