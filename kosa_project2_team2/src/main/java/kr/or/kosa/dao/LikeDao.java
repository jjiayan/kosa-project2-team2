package kr.or.kosa.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import kr.or.kosa.dto.LikeDto;
import kr.or.kosa.utils.ConnectionPoolHelper;

public class LikeDao {
	// 1. 좋아요 존재 여부 확인
	public boolean existsLike(LikeDto like) {
		return true;
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
		return 0;
	}
	
	// 4. 좋아요 개수 조회
	public int getLikeCnt(LikeDto like) {
		return 0;
	}
	
	// 5. 게시글 좋아요 상세정보 조회(사용자 목록) 
	public List<LikeDto> likeListByRoomBoardId(LikeDto like){
		return null;
	}
}
