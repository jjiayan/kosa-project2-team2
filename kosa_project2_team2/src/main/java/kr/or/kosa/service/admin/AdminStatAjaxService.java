package kr.or.kosa.service.admin;

import java.text.SimpleDateFormat;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.AdminDao;

public class AdminStatAjaxService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = null;
        try {
            AdminDao dao = new AdminDao();
            Gson gson = new Gson();
            JsonObject json = new JsonObject();

            // 안전하게 각각 개별 try로 감싸기
            try {
                Map<String, Integer> summary = dao.getDashboardSummary();
                json.add("summary", gson.toJsonTree(summary));
            } catch (Exception e) {
                System.err.println("요약 통계 로드 실패: " + e.getMessage());
                json.add("summary", gson.toJsonTree(Collections.emptyMap()));
            }

            try {
                List<Map<String, Object>> ageGroups = dao.getUserAgeDistribution();
                json.add("ageChart", gson.toJsonTree(ageGroups));
            } catch (Exception e) {
                System.err.println("연령대 통계 로드 실패: " + e.getMessage());
                json.add("ageChart", gson.toJsonTree(Collections.emptyList()));
            }

            try {
                Map<String, Double> participation = dao.getParticipationRate();
                json.add("participationChart", gson.toJsonTree(participation));
            } catch (Exception e) {
                System.err.println("참여율 통계 로드 실패: " + e.getMessage());
                json.add("participationChart", gson.toJsonTree(Collections.emptyMap()));
            }

            try {
                List<Map<String, Object>> topCerts = dao.getTopCertifications();
                json.add("topCerts", gson.toJsonTree(topCerts));
            } catch (Exception e) {
                System.err.println("자격증 TOP5 로드 실패: " + e.getMessage());
                json.add("topCerts", gson.toJsonTree(Collections.emptyList()));
            }

            String lastSyncTime = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm").format(new Date());
            json.addProperty("lastSyncTime", lastSyncTime);

            response.getWriter().write(gson.toJson(json));

        } catch (Exception e) {
            e.printStackTrace();
        }


        return forward;
    }
}
