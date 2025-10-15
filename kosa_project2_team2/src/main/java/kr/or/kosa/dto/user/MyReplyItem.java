package kr.or.kosa.dto.user;

import lombok.*;

@Getter @Setter @Builder
@AllArgsConstructor @NoArgsConstructor
public class MyReplyItem {
    private long replyId;
    private String content;     // 댓글 내용
    private String createdAt;   // 'YYYY.MM.DD'
    private long boardId;
    private String boardTitle;  // 부모 게시글 제목
    private long roomId;
    private String roomTitle;   // 모임명(ROOM_TITLE)
}