package kr.or.kosa.controller.certification;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.service.certification.CertificationListService;
import kr.or.kosa.service.certification.CertificationService;
import kr.or.kosa.service.certification.CertificationDetailService;


import java.io.IOException;

@WebServlet("*.cert")
public class CertificationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CertificationController() { super(); }

    private void doProcess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestUri = request.getRequestURI();         
        String contextPath = request.getContextPath();       
        String urlCommand = requestUri.substring(contextPath.length());

        System.out.println("urlCommand = " + urlCommand);

        Action action = null;
        ActionForward forward = null;

        // 현재 연도 최신 회차 기준 목록 JSP 출력
        if (urlCommand.equals("/certificationList.cert")) {
            action = new CertificationListService();
            forward = action.execute(request, response);

        // 상세 보기 (id 필요)
        } else if (urlCommand.equals("/certificationDetail.cert")) {
            action = new CertificationDetailService();
            forward = action.execute(request, response);

        // API → DB 동기화
        } else if (urlCommand.equals("/certificationSync.cert")) {
            CertificationService service = new CertificationService();
            service.syncAll(); 
            System.out.println("[Controller] Certification 동기화 수행 완료");

            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/certificationList.cert");

        // 그 외 → 에러 페이지 또는 404
        } else {
            forward = new ActionForward();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        // forward or redirect 실행
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
