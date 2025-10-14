package kr.or.kosa.dto;

import java.util.Date;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class AdminNoticeDto {
	private int adminNoticeId;
    private String adminNoticeTitle;
    private String adminNoticeContent;
    private Date createdAt;
    private int adminNoticeViewCnt; 
    private String userNickname;
}