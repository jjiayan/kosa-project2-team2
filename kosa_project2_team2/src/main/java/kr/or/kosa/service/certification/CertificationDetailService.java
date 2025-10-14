package kr.or.kosa.service.certification;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import kr.or.kosa.action.Action;
import kr.or.kosa.action.ActionForward;
import kr.or.kosa.dao.CertificationDao;
import kr.or.kosa.dto.CertificationChartDto;
import kr.or.kosa.dto.CertificationChartRowDto;
import kr.or.kosa.dto.CertificationDetailDto;

/**
 * 상세 화면 컨트롤러 + 비즈니스 로직 통합 버전
 * - 상세/회차 조회 (DAO)
 * - 통계 RAW 조회 (DAO)
 * - 최근 2년 필터 (현재 연도 제외)
 * - (year, implSeq)별 필기/실기 병합 → Chart DTO
 * - 정렬 (연도 desc, 회차 asc)
 * - 요약(평균 합격률/총 응시자) 계산
 * - JSP에 cert로 전달
 */
public class CertificationDetailService implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        ActionForward forward = new ActionForward();

        try {
            // 1) 파라미터
            int jmcd = Integer.parseInt(reqParam(request, "jmcd", true));
            String yearParam = reqParam(request, "year", false);
            String implSeqParam = reqParam(request, "implSeq", false);

            CertificationDao dao = new CertificationDao();
            CertificationDetailDto detailDto;

            // 2) 기본 상세 + 회차 목록
            if (isEmpty(yearParam) || isEmpty(implSeqParam)) {
                // 올해 최신 회차
                detailDto = dao.getCurrentYearLatestCertification(jmcd);
            } else {
                int year = Integer.parseInt(yearParam);
                int implSeq = Integer.parseInt(implSeqParam);
                detailDto = dao.getDetailWithRounds(jmcd, year, implSeq);
            }

            if (detailDto == null) {
                // 안전 처리
                forward.setRedirect(false);
                forward.setPath("/WEB-INF/views/error.jsp");
                return forward;
            }

            // 3) 통계 RAW 조회
            List<CertificationChartRowDto> rawList = dao.getStatsByJmcd(jmcd);

            // 4) 최근 2년 필터 (현재 연도 제외)
            int currentYear = detailDto.getYear();
            int y1 = currentYear - 1;
            int y2 = currentYear - 2;

            List<CertificationChartRowDto> filteredRaw = new ArrayList<>();
            for (CertificationChartRowDto r : rawList) {
                int y = r.getYear();
                if (y == y1 || y == y2) {
                    filteredRaw.add(r);
                }
            }

            // 5) (year, implSeq) 병합 → Chart DTO
            Map<String, CertificationChartDto> merged = new LinkedHashMap<>();
            for (CertificationChartRowDto r : filteredRaw) {
                String key = r.getYear() + "-" + r.getImplSeq();
                merged.putIfAbsent(key, new CertificationChartDto());

                CertificationChartDto chart = merged.get(key);
                chart.setJmcd(jmcd);
                chart.setYear(r.getYear());
                chart.setImplSeq(r.getImplSeq());

                String gb = safe(r.getExamGb());
                if ("필기".equals(gb)) {
                    chart.setDocRate(r.getPassRate());
                    chart.setDocApplicants(r.getApplicants());
                } else if ("실기".equals(gb)) {
                    chart.setPracRate(r.getPassRate());
                    chart.setPracApplicants(r.getApplicants());
                }
            }

            // 6) 정렬: 연도 desc → 회차 asc
            List<CertificationChartDto> chartList = new ArrayList<>(merged.values());
            chartList.sort((a, b) -> {
                if (a.getYear() != b.getYear()) return b.getYear() - a.getYear();
                return a.getImplSeq() - b.getImplSeq();
            });

            // 7) 요약 계산
            double sumDoc = 0, sumPrac = 0;
            int cntDoc = 0, cntPrac = 0;
            int totalApplicants = 0;

            for (CertificationChartDto c : chartList) {
                if (c.getDocRate() != null) { sumDoc += c.getDocRate(); cntDoc++; }
                if (c.getPracRate() != null) { sumPrac += c.getPracRate(); cntPrac++; }
                if (c.getDocApplicants() != null) totalApplicants += c.getDocApplicants();
                if (c.getPracApplicants() != null) totalApplicants += c.getPracApplicants();
            }

            Double avgDocRate = (cntDoc > 0 ? round1(sumDoc / cntDoc) : null);
            Double avgPracRate = (cntPrac > 0 ? round1(sumPrac / cntPrac) : null);

            // 8) DTO에 세팅
            detailDto.setChartList(chartList);
            detailDto.setAvgDocRate(avgDocRate);
            detailDto.setAvgPracRate(avgPracRate);
            detailDto.setTotalApplicants(totalApplicants);

            // 9) Request에 저장 + Forward
            request.setAttribute("cert", detailDto);
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/certification/certificationDetail.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            forward.setRedirect(false);
            forward.setPath("/WEB-INF/views/error.jsp");
        }

        return forward;
    }

    // ---------- Helpers ----------

    private static String reqParam(HttpServletRequest req, String name, boolean required) {
        String v = req.getParameter(name);
        if (required && (v == null || v.trim().isEmpty())) {
            throw new IllegalArgumentException("Missing required parameter: " + name);
        }
        return v;
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static double round1(double v) {
        return Math.round(v * 10.0) / 10.0;
    }
}
