package kr.or.kosa.dto;

import java.util.Date;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class RoomBoardDto {
	private int roomBoardId;
    private String roomBoardTitle;
    private String roomBoardContent;
    private Date updatedAt;
    private String roomBoardType;
    private String userNickname;
    private int roomBoardViewCnt;
    private int replyCount;
    private int likeCount;
    private String userPhoto;
    private int roomId;
    private int userId;
    private boolean likeStatus;
    private boolean isMyPost;
    
    
    
}
