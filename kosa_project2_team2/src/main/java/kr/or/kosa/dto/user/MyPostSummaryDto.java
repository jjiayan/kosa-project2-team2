package kr.or.kosa.dto.user;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MyPostSummaryDto {
    private long boardId;      // ROOM_BOARD.room_board_id
    private String boardTitle; // ROOM_BOARD.room_board_title
    private String category;   // CERTIFICATION_MASTER.jmName (종목명)
    private int likeCount;     // LIKE_ROOMBOARD count
    private int viewCount;     // ROOM_BOARD.room_board_view_cnt
    private String createdAt;  // TO_CHAR(created_at, 'YYYY.MM.DD')
}
