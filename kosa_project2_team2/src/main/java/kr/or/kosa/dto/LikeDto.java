package kr.or.kosa.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LikeDto {
	
	// 공통 
	private String targetType; 			// ROOM, ROOM_BOARD, REPLY
	private Long targetId;				// 대상ID
	private Long userId;				// user_id
	
	// 조회용
	private Integer likeCount;			// 좋아요 개수
	private Boolean isLiked; 			// 현재 사용자의 좋아요 여부 
	
	// 게시글용 
	private String userNickname;    	// 좋아요 누른 사용자 닉네임
    private String userPhoto;       	// 좋아요 누른 사용자 프로필 사진
    private Date likeCreatedAt;			// like_created_at(게시글용)
	
    // 페이징
    private Integer page;
    private Integer pageSize;
    private Integer offset;
    
    // Helper 메서드: 테이블명 반환
    public String getTableName() {
        switch(targetType) {
            case "ROOM": return "모임방좋아요";
            case "ROOM_BOARD": return "게시글좋아요";
            case "REPLY": return "댓글좋아요";
            default: throw new IllegalArgumentException("Invalid target type: " + targetType);
        }
    }
    
    // Helper 메서드: 컬럼명 반환
    public String getTargetColumnName() {
        switch(targetType) {
            case "ROOM": return "room_id";
            case "ROOM_BOARD": return "room_board_id";
            case "REPLY": return "reply_id";
            default: throw new IllegalArgumentException("Invalid target type: " + targetType);
        }
    }
	

	
	
}