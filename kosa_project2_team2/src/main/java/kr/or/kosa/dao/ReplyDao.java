package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.ReplyDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class ReplyDao {
	
	// 1. 댓글 목록 조회 (등록순/최신순)
	public List<ReplyDto> replyListByRoomBoardId(Long room_board_id, String orderby){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<ReplyDto> list = new ArrayList<>();
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT R.REPLY_ID, R.REPLY_CONTENT, R.USER_ID, R.ROOM_BOARD_ID, " +
					"R.REPLY_CREATED_AT, R.REPLY_UPDATED_AT, R.STATUS, R.PARENT_REPLY_ID, " +
					"U.USER_NICKNAME, U.USER_PHOTO " +
					"FROM REPLY R INNER JOIN \"USER\" U ON R.USER_ID = U.USER_ID " +
					"WHERE R.ROOM_BOARD_ID = ? AND R.STATUS IN ('ACTIVE', 'DELETED') " +
					"ORDER BY NVL(R.PARENT_REPLY_ID, R.REPLY_ID) " + orderby + ", " + 
					"CASE WHEN R.PARENT_REPLY_ID IS NULL THEN 0 ELSE 1 END ASC, " +
					"R.REPLY_CREATED_AT ASC";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, room_board_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ReplyDto reply = mapResultSetToDto(rs);
				list.add(reply);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return list;
	}
	
	// 2. 댓글 등록
	public int insertReply(ReplyDto reply) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int row = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "INSERT INTO REPLY (REPLY_CONTENT, USER_ID, ROOM_BOARD_ID, PARENT_REPLY_ID, STATUS) " +
					"VALUES (?, ?, ?, ?, 'ACTIVE')";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, reply.getReplyContent());
			pstmt.setLong(2, reply.getUserId());
			pstmt.setLong(3, reply.getRoomBoardId());
			
			// 대댓글일 경우 
			if (reply.getParentReplyId() != null && reply.getParentReplyId() > 0) {
				pstmt.setLong(4, reply.getParentReplyId());
			} else {
				pstmt.setNull(4, Types.NUMERIC);
			}
			System.out.println("=== 댓글 저장 디버깅 ===");
		    System.out.println("부모 댓글 ID: " + reply.getParentReplyId());
		    System.out.println("게시글 ID: " + reply.getRoomBoardId());
		    System.out.println("내용: " + reply.getReplyContent());
		    
			row = pstmt.executeUpdate();
					
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return row;
	}
	
	// 3. 댓글 수정
	public int updateReply(ReplyDto reply) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int row = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "UPDATE REPLY SET REPLY_CONTENT = ?, REPLY_UPDATED_AT = SYSDATE " +
					"WHERE REPLY_ID = ? AND USER_ID = ? AND STATUS = 'ACTIVE'";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, reply.getReplyContent());
			pstmt.setLong(2, reply.getReplyId());
			pstmt.setLong(3, reply.getUserId());
			
			row = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return row;
	}
	
	// 4. 댓글 삭제
	public int deleteReply(ReplyDto reply) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int row = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "UPDATE REPLY SET STATUS = 'DELETED', REPLY_UPDATED_AT = SYSDATE " +
					"WHERE REPLY_ID = ? AND USER_ID = ? AND STATUS = 'ACTIVE'";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, reply.getReplyId());
			pstmt.setLong(2, reply.getUserId());
			
			row = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return row;
	}
	
	// 5. 댓글 수 조회 
	public int getReplyCnt(Long roomBoardId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT COUNT(*) AS CNT FROM REPLY WHERE ROOM_BOARD_ID = ? AND STATUS = 'ACTIVE'";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, roomBoardId);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				count = rs.getInt("CNT");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return count;
	}
	
	// 6. 댓글 ID로 조회 (권한 체크용)
	public ReplyDto selectReplyById(Long replyId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ReplyDto reply = null;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT R.REPLY_ID, R.REPLY_CONTENT, R.USER_ID, R.ROOM_BOARD_ID, " +
					"R.REPLY_CREATED_AT, R.REPLY_UPDATED_AT, R.STATUS, R.PARENT_REPLY_ID, " +
					"U.USER_NICKNAME, U.USER_PHOTO " +
					"FROM REPLY R INNER JOIN \"USER\" U ON R.USER_ID = U.USER_ID " +
					"WHERE R.REPLY_ID = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, replyId);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				reply = mapResultSetToDto(rs);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return reply;
	}
	
	// ResultSet을 ReplyDto로 매핑하는 헬퍼 메서드
	private ReplyDto mapResultSetToDto(ResultSet rs) throws Exception {
		ReplyDto reply = new ReplyDto();
		
		reply.setReplyId(rs.getLong("reply_id"));
		reply.setReplyContent(rs.getString("reply_content"));
		reply.setUserId(rs.getLong("user_id"));
		reply.setRoomBoardId(rs.getLong("room_board_id"));
		
		Timestamp createdAt = rs.getTimestamp("reply_created_at");
		if (createdAt != null) {
			reply.setReplyCreatedAt(new java.util.Date(createdAt.getTime()));
		}
		
		Timestamp updatedAt = rs.getTimestamp("reply_updated_at");
		if (updatedAt != null) {
			reply.setReplyUpdatedAt(new java.util.Date(updatedAt.getTime()));
		}
		
		reply.setStatus(rs.getString("status"));
		
		long parentId = rs.getLong("parent_reply_id");
		if (!rs.wasNull()) {
			reply.setParentReplyId(parentId);
		}
		
		reply.setUserNickname(rs.getString("user_nickname"));
		reply.setUserPhoto(rs.getString("user_photo"));
		
		return reply;
	}
}