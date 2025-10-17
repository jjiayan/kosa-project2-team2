package kr.or.kosa.dto;

import java.util.Date;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Builder
@Getter
@ToString
public class RoomDto {
	private int roomId;    
	private int regionId;
	private int subRegionId;
    private int jmcd;
    private int year;
    private int implseq;
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
    private boolean isScore;
    private String certName;
    private boolean updateCheck;
    private String joinUserStatus;
    private boolean leaderCheck;
    private double roomScore;
    private String totalJmName;
    private String examgb; // 기사, 산업기사 
    private int userId;
    private String userNickName;
    private Date createdAt;
    private Date updatedAt;
    
}
