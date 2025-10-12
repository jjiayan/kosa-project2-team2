package kr.or.kosa.utils.certification;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppStartupListener] 서버 시작 감지 — 데이터 동기화 스케줄러 가동");
        DataSyncScheduler.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppStartupListener] 서버 종료 — 스케줄러 정지");
    }
}
