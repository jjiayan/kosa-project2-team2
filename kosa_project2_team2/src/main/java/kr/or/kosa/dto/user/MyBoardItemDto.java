package kr.or.kosa.dto.user;

import java.util.Date;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class MyBoardItemDto {
    private int roomBoardId;      // 게시글 PK
    private String boardTitle;    // 게시글 제목
    private Date createdAt;       // 작성일
    private int viewCount;        // 조회수
    private String boardType;     // 게시판 타입(공지/일반 등)
    private int roomId;           // 모임방 PK
    private String roomTitle;     // 모임방 제목
    private int replyCount;       // 활성 댓글 수
}
