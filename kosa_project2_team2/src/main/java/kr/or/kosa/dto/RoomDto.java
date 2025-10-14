package kr.or.kosa.dto;

import java.util.Date;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class RoomDto {
	private int roomId;    
	private int regionId;
    private String certificate1;
    private String certificate2;
    private int maxParticipant;
    private String thumbnailUrl;
    private String title;
     private String content;
    private String roomStatus;
    private String parentRegion;
    private String childRegion;
    private int participantCount;
    private int likeCount;
    private boolean isLiked;
    private String certName;
    private boolean updateCheck;
    private String joinUserStatus;
    private boolean leaderCheck;
    private double roomScore;
    private int userId;
    private String userNickName;
    private Date createdAt;
    private Date updatedAt;
    
}
