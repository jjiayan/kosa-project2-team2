package kr.or.kosa.utils.certification;

import java.util.Timer;
import java.util.TimerTask;
import java.util.Calendar;
import java.util.Date;

import kr.or.kosa.service.certification.CertificationService;


// 매일 오전 3시 정각에 외부 API → DB 동기화 수행하는 스케줄러
public class DataSyncScheduler {

    private static final long ONE_DAY = 24 * 60 * 60 * 1000L;
    private static Timer timer;

    /** 스케줄러 시작 */
    public static void start() {
        if (timer != null) {
            System.out.println("[DataSyncScheduler] 이미 실행 중입니다.");
            return;
        }

        timer = new Timer(true); // 데몬 스레드
        Date firstRun = getNextRunTime(3, 0, 0); // 오전 3시

        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                new CertificationService().syncAll();
            }
        }, firstRun, ONE_DAY);

        System.out.printf("[DataSyncScheduler] 매일 오전 3시에 실행 예약됨 (첫 실행: %s)%n", firstRun);
    }

    /** 다음 실행 시간 계산 */
    private static Date getNextRunTime(int hour, int minute, int second) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, hour);
        cal.set(Calendar.MINUTE, minute);
        cal.set(Calendar.SECOND, second);
        cal.set(Calendar.MILLISECOND, 0);

        // 이미 지난 시간이라면 내일로 예약
        if (cal.getTime().before(new Date())) {
            cal.add(Calendar.DATE, 1);
        }
        return cal.getTime();
    }

    /** 수동 즉시 실행용 */
    public static void runNow() {
        System.out.println("[DataSyncScheduler] ▶ 수동 동기화 실행");
        new CertificationService().syncAll();
    }
}

//package kr.or.kosa.utils.certification;
//
//import java.util.Timer;
//import java.util.TimerTask;
//
//import kr.or.kosa.service.certification.CertificationService;
//
//public class DataSyncScheduler {
//
//    private static Timer timer;
//
//    /** 스케줄러 시작 (테스트용: 10초 후 1회 실행) */
//    public static void start() {
//        if (timer != null) {
//            System.out.println("[DataSyncScheduler] 이미 실행 중입니다.");
//            return;
//        }
//
//        timer = new Timer(true); // 데몬 스레드
//
//        long delay = 10 * 1000L; // 10초
//
//        timer.schedule(new TimerTask() {
//            @Override
//            public void run() {
//                System.out.println("[DataSyncScheduler] 테스트 동기화 실행 (10초 후)");
//                new CertificationService().syncAll();
//            }
//        }, delay);
//
//        System.out.println("[DataSyncScheduler] 서버 시작 후 10초 뒤에 실행될 예정");
//    }
//
//    /** 수동 즉시 실행용 (기존 그대로 유지) */
//    public static void runNow() {
//        System.out.println("[DataSyncScheduler] ▶ 수동 동기화 실행");
//        new CertificationService().syncAll();
//    }
//}
//
//
