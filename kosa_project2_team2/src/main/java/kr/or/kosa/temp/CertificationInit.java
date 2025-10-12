package kr.or.kosa.temp;

import kr.or.kosa.service.certification.CertificationService;

/** [Manual DB Initialization Tool - 개발자 수동 실행용]
 * 
 * ✔ 목적
 *  - 프로젝트 초기 세팅 시 또는  DB가 비어 있을 경우
 *    외부 API에서 자격증 데이터를 불러와 DB에 저장하기 위한 스크립트입니다.
 *  - 실제 웹 애플리케이션 요청 흐름에서는 사용되지 않습니다.
 *
 * ✔ 사용 시점
 *  - 개발 환경에서 DB 초기화가 필요할 때 1회 실행
 *  - 운영 서버 배포 전에 사전 데이터 세팅용으로 사용 가능
 *  - 테스트 DB를 구축할 때도 활용 가능
 *
 * ✔ 실행 방법 (Java application으로 실행)
 *  1) IDE에서 이 클래스를 'Run As > Java Application' 실행
 *  2) 또는 jar로 패키징 후 java -cp 로 실행
 *
 * ✔ 주의사항
 *  - 기존 DB 데이터가 있을 경우 upsert 방식으로 병합됩니다.
 *  - 중복 삽입을 방지하는 upsert 로직이 CertificationDao에 구현되어 있어야 합니다.
 *  - 이 클래스는 운영 중 실시간 호출되지 않아야 하므로 temp 패키지에 위치시킵니다.
 *
 * ✔ 향후 대안 (선택 사항)
 *  - ServletContextListener를 통해 서버 시작 시 자동 동기화
 *  - 관리자 전용 페이지에서 "데이터 동기화" 기능 제공
 *  - 스케줄러(Cron, Quartz 등)로 정기 자동 동기화 구현
 *
 */
public class CertificationInit {

    public static void main(String[] args) {
        // 서비스 객체 생성 (DAO를 내부에서 주입받아 사용)
        CertificationService service = new CertificationService();

        // API -> DB 동기화 실행
        int result = service.syncFromApi();

        // 실행 결과 콘솔 출력
        System.out.println("✅ 초기 데이터 동기화 완료: " + result + "건 삽입 또는 업데이트 완료");
    }
}
