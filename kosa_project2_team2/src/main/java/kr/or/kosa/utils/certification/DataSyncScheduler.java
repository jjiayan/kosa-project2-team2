package kr.or.kosa.utils.certification;

import java.util.Timer;
import java.util.TimerTask;

import kr.or.kosa.service.certification.CertificationService;

public class DataSyncScheduler {

    private static Timer timer;

    /** 스케줄러 시작 (테스트용: 10초 후 1회 실행) */
    public static void start() {
        if (timer != null) {
            System.out.println("[DataSyncScheduler] 이미 실행 중입니다.");
            return;
        }

        timer = new Timer(true); // 데몬 스레드

        long delay = 10 * 1000L; // 10초

        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                System.out.println("[DataSyncScheduler] ✅ 테스트 동기화 실행 (10초 후)");
                new CertificationService().syncAll();
            }
        }, delay);

        System.out.println("[DataSyncScheduler] ⏰ 서버 시작 후 10초 뒤에 실행될 예정");
    }

    /** 수동 즉시 실행용 (기존 그대로 유지) */
    public static void runNow() {
        System.out.println("[DataSyncScheduler] ▶ 수동 동기화 실행");
        new CertificationService().syncAll();
    }
}
