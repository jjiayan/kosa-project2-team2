package kr.or.kosa.dto.user;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class RoomCardDto {
  private long roomId;
  private String title;
  private String certName;
  private String parentRegion;
  private String childRegion;
  private String updatedAt; // yyyy.MM.dd 형식으로 포맷해서 반환
  private int participantCount;
  private int maxParticipant;
  private int likeCount;
  private boolean liked;
  private String thumbnailUrl;
  private String status; // 모집중 등
}
