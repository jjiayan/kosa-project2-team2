package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kr.or.kosa.dto.LikeDto;
import kr.or.kosa.dto.ReplyDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class LikeDao {
	// 1. 좋아요 존재 여부 확인
	public boolean checkIsLiked(LikeDto like) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean isLiked = false;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT COUNT(*) AS CNT FROM " + like.getTableName() + 
                    " WHERE " + like.getTargetColumnName() + " = ? AND USER_ID = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, like.getTargetId());
            pstmt.setLong(2, like.getUserId());
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				isLiked = rs.getInt(1) > 0;
			}
			
		} catch (Exception e) {
			
		} finally {
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return isLiked;
	}
	
	// 2. 좋아요 추가
	public int insertLike(LikeDto like) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int row = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "INSERT INTO " + like.getTableName() +
						 " (" + like.getTargetColumnName() + ", user_id) VALUES (?, ?)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, like.getTargetId());
			pstmt.setLong(2, like.getUserId());
			
			row = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return row;
	}
	
	// 3. 좋아요 삭제
	public int deleteLike(LikeDto like) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int row = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			
			String sql = "DELETE FROM " + like.getTableName() +
						 " WHERE " + like.getTargetColumnName() + " = ? and user_id = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, like.getTargetId());
			pstmt.setLong(2, like.getUserId());
			
			row = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return row;
	}
	
	// 4. 좋아요 개수 조회
	public int getLikeCnt(LikeDto like) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT COUNT(*) AS CNT FROM " + like.getTableName() +
						 " WHERE " + like.getTargetColumnName() + " = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, like.getTargetId());
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
	
	// 5. 게시글 좋아요 상세정보 조회(사용자 목록) - 쿼리문 수정 필요 
	public List<LikeDto> likeListByRoomBoardId(LikeDto like){
			
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<LikeDto> list = new ArrayList<>();
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT L.USER_ID, L.ROOM_BOARD_ID, L.LIKE_CREATED_AT, U.USER_PHOTO, U.USER_NICKNAME, U.USER_STATUS " +
						 "FROM LIKE_ROOM_BOARD L INNER JOIN \"USER\" U ON L.USER_ID = U.USER_ID " +
						 "WHERE L.ROOM_BOARD_ID = ? AND U.USER_STATUS = 'ACTIVE'" +
						 "ORDER BY L.LIKE_CREATED_AT DESC";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, like.getTargetId());
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				LikeDto likes = new LikeDto();
				likes.setUserId(rs.getLong("USER_ID"));
	            likes.setUserNickname(rs.getString("USER_NICKNAME"));
	            likes.setUserPhoto(rs.getString("USER_PHOTO"));
	            likes.setLikeCreatedAt(rs.getTimestamp("LIKE_CREATED_AT"));
	            list.add(likes);
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
	
	// 페이지네이션이 적용된 좋아요 목록 조회 메서드 추가
	public List<LikeDto> likeListByRoomBoardIdWithPaging(LikeDto like, int offset, int limit){
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<LikeDto> list = new ArrayList<>();
	    
	    try {
	        conn = ConnectionPoolHelper.getConnection();
	        String sql = "SELECT * FROM (" +
	                "SELECT L.USER_ID, L.ROOM_BOARD_ID, L.LIKE_CREATED_AT, " +
	                "U.USER_PHOTO, U.USER_NICKNAME, U.USER_STATUS, " +
	                "ROW_NUMBER() OVER (ORDER BY L.LIKE_CREATED_AT DESC) AS RN " +
	                "FROM LIKE_ROOM_BOARD L INNER JOIN \"USER\" U ON L.USER_ID = U.USER_ID " +
	                "WHERE L.ROOM_BOARD_ID = ? AND U.USER_STATUS = 'ACTIVE'" +
	                ") WHERE RN BETWEEN ? AND ?";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setLong(1, like.getTargetId());
	        pstmt.setInt(2, offset + 1);
	        pstmt.setInt(3, offset + limit);
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            LikeDto likes = new LikeDto();
	            likes.setUserId(rs.getLong("USER_ID"));
	            likes.setUserNickname(rs.getString("USER_NICKNAME"));
	            likes.setUserPhoto(rs.getString("USER_PHOTO"));
	            likes.setLikeCreatedAt(rs.getTimestamp("LIKE_CREATED_AT"));
	            list.add(likes);
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
}
