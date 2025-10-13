package kr.or.kosa.controller.certification.sync;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.certification.sync.CertificationMasterSyncService;
import kr.or.kosa.service.certification.sync.CertificationScheduleSyncService;
import kr.or.kosa.service.certification.sync.CertificationStatsSyncService;

import java.io.IOException;

@WebServlet("*.sync")   // 예: /syncMaster.sync, /syncSchedule.sync, /syncStats.sync
public class CertificationSyncController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CertificationSyncController() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestUri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String urlCommand = requestUri.substring(contextPath.length());

        System.out.println("[SyncController] urlCommand = " + urlCommand);

        Action action = null;
        ActionForward forward = null;

        // 자격증 기본정보 동기화  (/syncMaster.sync)
        if (urlCommand.equals("/syncMaster.sync")) {
            action = new CertificationMasterSyncService();
            forward = action.execute(request, response);

        // 시험 일정 동기화 (/syncSchedule.sync)
        } else if (urlCommand.equals("/syncSchedule.sync")) {
            action = new CertificationScheduleSyncService();
            forward = action.execute(request, response);

        // 시험 통계 동기화 (/syncStats.sync)
        } else if (urlCommand.equals("/syncStats.sync")) {
            action = new CertificationStatsSyncService();
            forward = action.execute(request, response);
        }

        // 공통 포워딩 처리
        if (forward != null) {
            if (forward.isRedirect()) {
                response.sendRedirect(forward.getPath());
            } else {
                RequestDispatcher dis = request.getRequestDispatcher(forward.getPath());
                dis.forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doProcess(request, response);
    }
}
