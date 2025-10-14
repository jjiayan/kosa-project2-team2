package kr.or.kosa.dto.user;

import java.sql.Timestamp;

public class MyPostItem {
    private int roomBoardId;
    private String title;
    private Timestamp createdAt;
    private int roomId;

    public int getRoomBoardId() { return roomBoardId; }
    public void setRoomBoardId(int roomBoardId) { this.roomBoardId = roomBoardId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
}