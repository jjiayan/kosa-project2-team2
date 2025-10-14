package kr.or.kosa.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReplyDto {
    
    // 기본 댓글 정보 (DB 컬럼과 매핑)
    private Long replyId;               // reply_id
    private String replyContent;        // reply_content
    private Long userId;                // user_id
    private Long roomBoardId;           // room_board_id
    private Date replyCreatedAt;        // reply_created_at
    private Date replyUpdatedAt;        // reply_updated_at
    private String status;              // status (ACTIVE/DELETED)
    private Long parentReplyId;         // parent_reply_id
    
    // 조인으로 가져올 추가 정보
    private String userNickname;        // 작성자 닉네임
    private String userPhoto;           // 작성자 프로필 사진
    
    // 화면 표시용 추가 정보
    private int likeCount;              // 좋아요 수
    private boolean isLiked;            // 현재 사용자의 좋아요 여부
    private int replyCount;             // 대댓글 수
    private boolean owner;				// 댓글 소유자 여부(추가)
    
    // 대댓글 리스트 (계층 구조 표현용)
    private List<ReplyDto> replies;
    
}