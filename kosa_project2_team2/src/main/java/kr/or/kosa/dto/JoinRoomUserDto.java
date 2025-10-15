package kr.or.kosa.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class JoinRoomUserDto {
	private int userId;
    private int roomId;
    private String roomTier;
    private String userNickname;
    private String userPhoto;
}
