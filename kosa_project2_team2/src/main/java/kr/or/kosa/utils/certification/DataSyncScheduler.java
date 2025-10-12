package kr.or.kosa.utils.certification;

import java.util.Timer;
import java.util.TimerTask;
import kr.or.kosa.service.certification.CertificationService;

public class DataSyncScheduler {
    private static final long INTERVAL = 1000L * 60 * 60 * 6; // 6시간마다 동기화
    private static Timer timer = new Timer(true);

    public static void start() {
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                System.out.println("[Scheduler] 자격증 데이터 자동 동기화 시작...");

                CertificationService service = new CertificationService();

                try {
                    int result = service.syncFromApi();
                    System.out.println("[Scheduler] 동기화 완료 (" + result + "건 반영)");
                } catch (Exception e) {
                    System.err.println("[Scheduler] 동기화 실패: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }, 0, INTERVAL); // 톰캣 시작 시 즉시 실행 후 주기 반복
    }
}

