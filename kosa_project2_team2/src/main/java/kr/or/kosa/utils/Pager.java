package kr.or.kosa.utils;

public class Pager {
    
    // 페이지네이션 타입 정의
    public static final String TYPE_REPLY = "REPLY";
    public static final String TYPE_LIKE = "LIKE";
    
    private int pageSize;       // 한 페이지당 데이터 개수
    private int pagerSize = 5;  // 페이지 링크 개수
    private int dataCount;      // 총 데이터 수
    private int currentPage;    // 현재 페이지
    private int pageCount;      // 총 페이지 수
    private String type;        // 페이지네이션 타입
    
    /**
     * 타입별 기본 페이지 사이즈로 생성
     * @param dataCount 총 데이터 수
     * @param currentPage 현재 페이지
     * @param type 페이지네이션 타입 (TYPE_REPLY 또는 TYPE_LIKE)
     */
    public Pager(int dataCount, int currentPage, String type) {
        this.dataCount = dataCount;
        this.currentPage = currentPage;
        this.type = type;
        
        // 타입에 따른 기본 페이지 사이즈 설정
        if (TYPE_REPLY.equals(type)) {
            this.pageSize = 30;  // 댓글: 30개씩
        } else if (TYPE_LIKE.equals(type)) {
            this.pageSize = 10;  // 좋아요: 10개씩
        } else {
            this.pageSize = 10;  // 기본값
        }
        
        this.pageCount = (dataCount / pageSize) + ((dataCount % pageSize) > 0 ? 1 : 0);
    }
    
    /**
     * 커스텀 페이지 사이즈로 생성
     * @param dataCount 총 데이터 수
     * @param currentPage 현재 페이지
     * @param pageSize 페이지 사이즈
     * @param type 페이지네이션 타입
     */
    public Pager(int dataCount, int currentPage, int pageSize, String type) {
        this.dataCount = dataCount;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.type = type;
        this.pageCount = (dataCount / pageSize) + ((dataCount % pageSize) > 0 ? 1 : 0);
    }
    
    /**
     * 현재 페이지의 데이터 시작 인덱스 (0부터 시작)
     */
    public int getOffset() {
        return (currentPage - 1) * pageSize;
    }
    
    /**
     * 한 페이지에 표시할 데이터 개수
     */
    public int getLimit() {
        return pageSize;
    }
    
    /**
     * 이전 페이지 존재 여부
     */
    public boolean hasPreviousPage() {
        return currentPage > 1;
    }
    
    /**
     * 다음 페이지 존재 여부
     */
    public boolean hasNextPage() {
        return currentPage < pageCount;
    }
    
    /**
     * 페이지 범위 계산 (페이지네이션 UI용)
     */
    public int getStartPage() {
        int start = Math.max(1, currentPage - (pagerSize / 2));
        int end = Math.min(pageCount, start + pagerSize - 1);
        
        // 끝 페이지가 조정되었다면 시작 페이지도 재조정
        if (end - start < pagerSize - 1) {
            start = Math.max(1, end - pagerSize + 1);
        }
        
        return start;
    }
    
    public int getEndPage() {
        int start = getStartPage();
        return Math.min(pageCount, start + pagerSize - 1);
    }
    
    // Getters
    public int getPageSize() { return pageSize; }
    public int getPagerSize() { return pagerSize; }
    public int getDataCount() { return dataCount; }
    public int getCurrentPage() { return currentPage; }
    public int getPageCount() { return pageCount; }
    public String getType() { return type; }
    
    // Setters
    public void setPagerSize(int pagerSize) { this.pagerSize = pagerSize; }
}