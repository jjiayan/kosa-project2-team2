package kr.or.kosa.utils.certification;

import java.util.Timer;
import java.util.TimerTask;

import kr.or.kosa.service.certification.CertificationSyncService;

/**
 * - 일정 주기로 외부 API → DB 동기화 수행
 * - 서버 시작 시 자동 실행 (Listener 등에서 start() 호출)
 */
public class DataSyncScheduler {
    
    // 6시간 마다 실행 (1000ms * 60s * 60m * 6h)
    private static final long INTERVAL = 1000L * 60 * 60 * 6;
    
    // 데몬 스레드로 동작하는 Timer
    private static Timer timer = new Timer(true);

    public static void start() {
        timer.scheduleAtFixedRate(new TimerTask() {

            @Override
            public void run() {
                System.out.println("[Scheduler] 자격증 데이터 자동 동기화 시작...");

                CertificationSyncService syncService = new CertificationSyncService();

                try {
                    int result = syncService.syncFromApi();
                    System.out.println("[Scheduler] 동기화 완료 (" + result + "건 반영)");
                } catch (Exception e) {
                    System.err.println("[Scheduler] 동기화 실패: " + e.getMessage());
                    e.printStackTrace();
                }
            }

        }, 0, INTERVAL);   // 톰캣 시작 시 즉시 실행 후 주기적 반복
    }
}
