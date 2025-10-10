package kr.or.kosa.utils.certification;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import kr.or.kosa.utils.certification.DataSyncScheduler;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🌐 서버 시작: 자격증 데이터 스케줄러 등록");
        DataSyncScheduler.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 서버 종료: 스케줄러 중지");
    }
}
