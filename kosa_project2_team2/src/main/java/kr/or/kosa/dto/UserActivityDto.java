package kr.or.kosa.dto;

import java.sql.Timestamp;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserActivityDto {
    // 사용자 기본 정보
    private Long userId;
    private String userNickname;
    private String userPhoto;
    private String userStatus;
    private String authorNickname;
    private Timestamp likeCreatedAt;

    // 게시글/댓글 정보
    private Long roomBoardId;
    private Long replyId;
    private String title;
    private String content;
    private Date createdAt;
    private Date updatedAt;
    private Integer viewCount;
    private Integer likeCount;
    private Integer replyCount;
    
    // 모임방 정보
    private Long roomId;
    private String roomTitle;
    
    // 사용자 역할 정보 (JoinRoomUserDto 참고)
    private String roomTier;  // 모임방 내 등급/역할
    
    // 활동 타입 구분
    private String activityType; // POST, COMMENT, COMMENTED_POST, LIKED_POST
    
    // 페이징 정보
    private Integer page;
    private Integer pageSize;
    private Integer totalCount;
    private Integer totalPages;
    
    // 추가 정보
    private String boardType;
    private Boolean isMyActivity;
}