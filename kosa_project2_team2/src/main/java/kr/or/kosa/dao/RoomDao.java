package kr.or.kosa.dao;


import kr.or.kosa.dto.JoinRoomUserDto;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.RoomBoardDto;
import kr.or.kosa.dto.RoomDto;
import kr.or.kosa.dto.SearchCondition;
import kr.or.kosa.dto.user.MyPostItem;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class RoomDao {
	
	public int insertRoom(RoomDto insertRoomDto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int result = 0;
		int generatedRoomId = 0;
		
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			conn.setAutoCommit(false);
			
			String sql1 = "INSERT INTO ROOM (room_title, room_content, room_thumbnail, maxParticipant, region_id, jmcd, year, implSeq ) VALUES ("
					+ "?, ?, ?, ?, ?, ?, ?, ?)";
			
			
			pstmt = conn.prepareStatement(sql1, new String[]{"room_id"}); // 생성된 키 반환 설정
	        pstmt.setString(1, insertRoomDto.getTitle());
	        pstmt.setString(2, insertRoomDto.getContent());
	        pstmt.setString(3, insertRoomDto.getThumbnailUrl());
	        pstmt.setInt(4, insertRoomDto.getMaxParticipant());
	        pstmt.setInt(5, insertRoomDto.getRegionId());
	        pstmt.setInt(6, 1320); // certificate1
	        pstmt.setInt(7, 2025); // certificate2 (년도)
	        pstmt.setInt(8, 1); // certificate3 (회차)
			
	        
	        result = pstmt.executeUpdate();
	        rs = pstmt.getGeneratedKeys();
	        if (rs.next()) {
	            generatedRoomId = rs.getInt(1);
	        }
	        
	        
	        
			String sql2 = "INSERT INTO JOIN_ROOM (user_id, room_id, room_tier) \n"
					+ "VALUES (?, ?, 'LEADER')";
			
			pstmt2 = conn.prepareStatement(sql2);
			pstmt2.setInt(1, insertRoomDto.getUserId());
			pstmt2.setInt(2, generatedRoomId);
			
			pstmt2.execute();
			
			conn.commit();
			
			
			
		} catch (SQLException e) {
			if (conn != null) {
	            try {
	                conn.rollback(); // 에러 발생 시 롤백
	            } catch (SQLException ex) {
	                ex.printStackTrace();
	            }
	        }
	        e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(pstmt2);
			ConnectionPoolHelper.close(conn);
		}
		return generatedRoomId;
		
	}
	
	public PageResult<RoomDto> getRoomsBySearch(SearchCondition searchCondition){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<RoomDto> roomList = new ArrayList<>();
		PageResult<RoomDto> pageResult = new PageResult();
		try {
		
			conn = ConnectionPoolHelper.getConnection();
		
			StringBuilder sql = new StringBuilder();
	        sql.append("SELECT ");
	        sql.append("  ro.ROOM_ID AS room_id, ");
	        sql.append("  ro.ROOM_TITLE AS room_title, ");
	        sql.append("  ro.ROOM_THUMBNAIL AS room_thumbnail, ");
	        sql.append("  ro.MAXPARTICIPANT AS max_participant, ");
	        sql.append("  ro.ROOM_STATUS AS room_status, ");
	        sql.append("  ro.updated_at AS updated_at, ");
	        sql.append("  CASE WHEN updated_at > created_at THEN 1 ELSE 0 END update_check, ");
	        sql.append("  r2.REGION_NAME AS parent_region, ");
	        sql.append("  r1.REGION_NAME AS child_region, ");
	        sql.append("  (SELECT COUNT(*) FROM JOIN_ROOM jr WHERE jr.ROOM_ID = ro.ROOM_ID AND ROOM_TIER != 'PENDING') AS participant_count, ");
	        sql.append("  (SELECT COUNT(*) FROM LIKE_ROOM lr WHERE lr.ROOM_ID = ro.ROOM_ID) AS like_count, ");
	        sql.append("  cm.JMNAME AS cert_name, ");
	        sql.append("CASE WHEN lr.USER_ID IS NOT NULL THEN 1 ELSE 0 END AS is_liked ");
	        sql.append("FROM ROOM ro ");
	        sql.append("JOIN REGION r1 ON r1.REGION_ID = ro.REGION_ID ");
	        sql.append("JOIN REGION r2 ON r2.REGION_ID = r1.PARENT_ID ");
	        sql.append("JOIN CERTIFICATION_MASTER cm ON cm.JMCD = ro.JMCD ");
	        sql.append("  AND cm.YEAR = ro.YEAR ");
	        sql.append("  AND cm.IMPLSEQ = ro.IMPLSEQ ");
	       //유저가 있다면 없다면 체크하는거 추가 해야한다.
	        sql.append("LEFT JOIN LIKE_ROOM lr ON lr.ROOM_ID = ro.ROOM_ID AND lr.USER_ID = ?");
	        sql.append("WHERE 1=1 ");
	        sql.append("AND is_deleted = 'N' ");
	        // 서울시 이런식으로 있다면
	        if (searchCondition.getSi() != null && !searchCondition.getSi().isEmpty()) {
	            sql.append("AND r2.REGION_ID = ? ");
	        }
	        // ~구가 있다면
	        if (searchCondition.getSiGun() != null && !searchCondition.getSiGun().isEmpty()) {
	            sql.append("AND r1.REGION_ID = ? ");
	        }
	        // 검색어가 있다면
	        if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().isEmpty()) {
	            sql.append("AND ro.ROOM_TITLE LIKE ? ");
	        }
	        sql.append("ORDER BY ro.ROOM_ID DESC ");
	        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
			pstmt = conn.prepareStatement(sql.toString());
			System.out.println("2");
			
			int paramIndex = 1;
			pstmt.setInt(paramIndex++, 1); // 이거는 유저아이디가 들어간다.
			
			if (searchCondition.getSi() != null && !searchCondition.getSi().isEmpty()) {
	            pstmt.setInt(paramIndex++, Integer.parseInt(searchCondition.getSi()));
	        }
	        
	        if (searchCondition.getSiGun() != null && !searchCondition.getSiGun().isEmpty()) {
	            pstmt.setInt(paramIndex++, Integer.parseInt(searchCondition.getSiGun()));
	        }
	        
	        if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + searchCondition.getKeyword() + "%");
	        }
	        
	        // 페이징
	        pstmt.setInt(paramIndex++, searchCondition.getOffset());
	        pstmt.setInt(paramIndex++, searchCondition.getSize());
	        
	        int totalCount = getTotalCount(conn, searchCondition);
	        if(totalCount == 0) {
	        	System.out.println("조회결과없다.");
	        }
	        
	        pageResult.setTotalCount(totalCount);
	        int totalPages = (int) Math.ceil((double) totalCount / searchCondition.getSize());
	        pageResult.setTotalPages(totalPages);
	        

			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String roomStatus = "모집중";
			
				
				if(rs.getString("room_status").equals("RECRUITING"))
					roomStatus = "모집중";
				else roomStatus = "마감";
					
				RoomDto room = RoomDto.builder()
		                .roomId(rs.getInt("room_id"))
		                .title(rs.getString("room_title"))
		                .thumbnailUrl(rs.getString("room_thumbnail"))
		                .maxParticipant(rs.getInt("max_participant"))
		                .roomStatus(roomStatus)
		                .parentRegion(rs.getString("parent_region"))
		                .childRegion(rs.getString("child_region"))
		                .participantCount(rs.getInt("participant_count"))
		                .likeCount(rs.getInt("like_count"))
		                .certName(rs.getString("cert_name"))
		                .isLiked(rs.getBoolean("is_liked"))
		                .updatedAt(rs.getDate("updated_at"))
		                .updateCheck(rs.getBoolean("update_check"))
		                .build();
			
				roomList.add(room);
			
			}
			List<RegionDto> mainResion = getRegion(conn);
			pageResult.setMainRegionList(mainResion);
		
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		pageResult.setData(roomList);
		pageResult.setCurrentPage(searchCondition.getPage());
		pageResult.setPageSize(searchCondition.getSize());
		pageResult.setKeyword(searchCondition.getKeyword());
		pageResult.setSi(searchCondition.getSi());
		pageResult.setSiGun(searchCondition.getSiGun());
		
		
		return pageResult;
		
	}
	
	
	
	public RoomDto detialRoom(int roomId, int userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RoomDto roomDetail = null;
		
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			StringBuilder sqlBuilder = new StringBuilder();
			sqlBuilder.append("SELECT ro.room_id, ro.room_title, ro.room_content, ");
			sqlBuilder.append("ro.updated_at, u.user_nickname, ");
			sqlBuilder.append("(SELECT COUNT(*) FROM LIKE_ROOM lr WHERE lr.room_id = ro.room_id) AS like_count, ");
			sqlBuilder.append("(SELECT CASE WHEN ROUND(AVG(score), 1) IS NOT NULL THEN ROUND(AVG(score), 1) ELSE 0 END ");
			sqlBuilder.append("FROM ROOM_SCORE rs WHERE rs.room_id = ro.room_id) AS room_score, ");
			sqlBuilder.append("NVL(jr2.ROOM_TIER, 'NOT_JOINED') AS join_status, ");
			sqlBuilder.append("CASE WHEN lr.USER_ID IS NOT NULL THEN 1 ELSE 0 END AS is_liked, ");
			sqlBuilder.append("CASE WHEN u.USER_ID = ? THEN 1 ELSE 0 END AS leader_check ");			
			sqlBuilder.append("FROM room ro ");
			sqlBuilder.append("JOIN JOIN_ROOM jr ON jr.room_id = ro.room_id ");
			sqlBuilder.append("JOIN \"USER\" u ON u.user_id = jr.user_id ");
			sqlBuilder.append("LEFT JOIN LIKE_ROOM lr ON lr.ROOM_ID = ro.ROOM_ID AND lr.USER_ID = ? ");
			sqlBuilder.append("LEFT JOIN JOIN_ROOM jr2 ON jr2.USER_ID = ? AND jr2.ROOM_ID = ? ");
			sqlBuilder.append("WHERE ro.room_id = ? AND jr.room_tier = 'LEADER'");
			
			String sql = sqlBuilder.toString();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId); // 현재 접속 유저 아이디
			pstmt.setInt(2, userId); // 현재 접속 유저 아이디
			pstmt.setInt(3, userId);
			pstmt.setInt(4, roomId);
			pstmt.setInt(5, roomId); // 현재 접속 유저 아이디
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				roomDetail =  RoomDto.builder()
						.roomId(rs.getInt("room_id"))
				        .title(rs.getString("room_title"))
				        .content(rs.getString("room_content"))
				        .updatedAt(rs.getTimestamp("updated_at"))
				        .userNickName(rs.getString("user_nickname"))
				        .likeCount(rs.getInt("like_count"))
				        .joinUserStatus(rs.getString("join_status"))
				        .roomScore(rs.getDouble("room_score"))
				        .isLiked(rs.getInt("is_liked") == 1)
				        .leaderCheck(rs.getInt("leader_check") == 1)
						.build();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return roomDetail;
		
	}
	
	
	public int joinRoom(int userId, int roomId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		
		String sql = "INSERT INTO JOIN_ROOM (user_id, room_id, room_tier) "
				+ "VALUES (?, ?, 'PENDING')";
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, roomId);
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return (result == 1) ? roomId : result; 
		
	}
	
	
	
	// 룸보드 게시판 검색
	public List<RoomBoardDto> getRoomBoardBySearch(SearchCondition searchCondition, int roomId, String roomBoardType) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<RoomBoardDto> roomBoardList = new ArrayList<>();
		
		StringBuilder sqlBuilder = new StringBuilder();
		
		sqlBuilder.append("SELECT rb.ROOM_BOARD_ID as ROOM_BOARD_ID, ")
        .append("       rb.ROOM_BOARD_TITLE as ROOM_BOARD_TITLE, ")
        .append("       rb.UPDATED_AT as UPDATED_AT, ")
        .append("       rb.ROOM_BOARD_VIEW_CNT as ROOM_BOARD_VIEW_CNT, ")
        .append("       u.USER_NICKNAME as USER_NICKNAME, ")
        .append("       (SELECT COUNT(*) ")
        .append("        FROM \"REPLY\" r ")
        .append("        WHERE r.ROOM_BOARD_ID = rb.ROOM_BOARD_ID ")
        .append("        AND r.PARENT_REPLY_ID IS NULL) AS reply_count ")
        .append("FROM ROOM_BOARD rb \n")
        .append("JOIN \"USER\" u ON u.USER_ID = rb.USER_ID ")
		.append("WHERE ROOM_BOARD_TYPE = ? AND rb.ROOM_ID = ? ")
		.append("AND rb.IS_DELETED = 'N' ");
		
		if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().trim().isEmpty()) {
		    String whereClause = "AND rb.ROOM_BOARD_TITLE LIKE ? ";
		    sqlBuilder.append(whereClause);
		}
		sqlBuilder.append("ORDER BY rb.ROOM_BOARD_ID DESC ")
        .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
		String sql = sqlBuilder.toString();
		int paramIndex = 1;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(paramIndex++, roomBoardType);
			pstmt.setInt(paramIndex++, roomId);
			
			if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().trim().isEmpty()) {
			    pstmt.setString(paramIndex++, "%" + searchCondition.getKeyword() + "%");
			}
			// 페이지네이션 파라미터
			pstmt.setInt(paramIndex++, searchCondition.getRoomBoardOffset());
			pstmt.setInt(paramIndex, searchCondition.getRoomBoardSize());
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				RoomBoardDto roomBoard = RoomBoardDto.builder()
				        .roomBoardId(rs.getInt("ROOM_BOARD_ID"))
				        .roomBoardTitle(rs.getString("ROOM_BOARD_TITLE"))
				        .updatedAt(rs.getTimestamp("UPDATED_AT"))
				        .roomBoardViewCnt(rs.getInt("ROOM_BOARD_VIEW_CNT"))
				        .userNickname(rs.getString("USER_NICKNAME"))
				        .replyCount(rs.getInt("reply_count"))
				        .build();
			
				roomBoardList.add(roomBoard);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return roomBoardList;
	}
	
	public RoomBoardDto getRoomBoardDetail(int roomBoardId, int userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RoomBoardDto roomBoard = null; 
    
		String sql = "SELECT " +
			    "rb.ROOM_BOARD_ID as ROOM_BOARD_ID, " +
			    "rb.ROOM_BOARD_TITLE as ROOM_BOARD_TITLE, " +
			    "rb.ROOM_BOARD_CONTENT as ROOM_BOARD_CONTENT, " +
			    "rb.UPDATED_AT as UPDATED_AT, " +
			    "rb.ROOM_BOARD_VIEW_CNT as ROOM_BOARD_VIEW_CNT, " +
			    "rb.ROOM_BOARD_TYPE as ROOM_BOARD_TYPE, " +
			    "u.USER_PHOTO as USER_PHOTO, " +
			    "(SELECT COUNT(*) " +
			    "FROM LIKE_ROOM_BOARD " +
			    "WHERE ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS like_count, " +
			    "NVL(lrb.USER_ID, 0) AS like_status, " +
			    "(SELECT CASE " +
			    "WHEN rb.USER_ID = ? THEN 1 " +
			    "ELSE 0 " +
			    "END " +
			    "FROM DUAL) AS is_my_post " +
			    "FROM ROOM_BOARD rb " +
			    "JOIN \"USER\" u ON u.USER_ID = rb.USER_ID " +
			    "LEFT JOIN LIKE_ROOM_BOARD lrb " +
			    "ON lrb.USER_ID = ? " +
			    "AND lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
			    "WHERE rb.ROOM_BOARD_ID = ? AND rb.IS_DELETED = 'N'";
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, userId);
			pstmt.setInt(3, roomBoardId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				 roomBoard = RoomBoardDto.builder()
				        .roomBoardId(rs.getInt("ROOM_BOARD_ID"))
				        .roomBoardTitle(rs.getString("ROOM_BOARD_TITLE"))
				        .roomBoardContent(rs.getString("ROOM_BOARD_CONTENT"))
				        .updatedAt(rs.getDate("UPDATED_AT"))
				        .roomBoardViewCnt(rs.getInt("ROOM_BOARD_VIEW_CNT"))
				        .userPhoto(rs.getString("USER_PHOTO"))
				        .likeCount(rs.getInt("like_count"))
				        .likeStatus(rs.getInt("like_status") == 1)
				        .isMyPost(rs.getInt("is_my_post") == 1)
				        .build();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return roomBoard;
	}
	
	// 룸보드 업데이트 정보반환
	public RoomBoardDto getUpdateInfoRoomDetail(int roomBoardId, String roomBoardType) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RoomBoardDto roomBoardDto = null;
		
		String sql = "SELECT "
				+ "rb.ROOM_BOARD_ID as roomBoardId, "
				+ "rb.ROOM_BOARD_TITLE as roomBoardTitle, "
				+ "rb.ROOM_BOARD_CONTENT as roomBoardContent, "
				+ "rb.ROOM_BOARD_TYPE as roomBoardType "
				+ "FROM ROOM_BOARD rb "
				+ "WHERE rb.ROOM_BOARD_ID = ? AND rb.ROOM_BOARD_TYPE = ?";
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, roomBoardId);
			pstmt.setString(2, roomBoardType);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				roomBoardDto = RoomBoardDto.builder()
				.roomBoardId(rs.getInt("roomBoardId"))
				.roomBoardTitle(rs.getString("roomBoardTitle"))
				.roomBoardContent(rs.getString("roomBoardContent"))
				.roomBoardType(rs.getString("roomBoardType"))
				.build();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return roomBoardDto;
	}
	
	// 모임보드 업데이트 
	public int updateRoomBoard(RoomBoardDto updateRoomDto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		int roomBoardId = 0;
		
		String sql = "UPDATE room_board "
				+ "SET room_board_title = ?, "
				+ "room_board_content = ?, "
				+ "updated_at = SYSDATE "
				+ "WHERE room_board_id = ?";
		
		try {
			
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, updateRoomDto.getRoomBoardTitle());
			pstmt.setString(2, updateRoomDto.getRoomBoardContent());
			pstmt.setInt(3, updateRoomDto.getRoomBoardId());
			
			result = pstmt.executeUpdate();
			if(result > 0) roomBoardId = updateRoomDto.getRoomBoardId();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return roomBoardId;
		
	}
	
	public int deleteRoomBoard(int roomBoardId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		
		String sql = "UPDATE room_board "
				+ "SET IS_DELETED = 'Y' "
				+ "WHERE room_board_id = ?";
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, roomBoardId);
			result = pstmt.executeUpdate();
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return result;
	}
	
	
	private int getTotalCount(Connection conn, SearchCondition searchCondition) throws SQLException {
	    StringBuilder sql = new StringBuilder();
	    sql.append("SELECT COUNT(*) ");
	    sql.append("FROM ROOM ro ");
	    sql.append("JOIN REGION r1 ON r1.REGION_ID = ro.REGION_ID ");
	    sql.append("JOIN REGION r2 ON r2.REGION_ID = r1.PARENT_ID ");
	    sql.append("JOIN CERTIFICATION_MASTER cm ON cm.JMCD = ro.JMCD ");
	    sql.append("  AND cm.YEAR = ro.YEAR ");
	    sql.append("  AND cm.IMPLSEQ = ro.IMPLSEQ ");
	    sql.append("WHERE 1=1 ");
	    
	    if (searchCondition.getSi() != null && !searchCondition.getSi().isEmpty()) {
	        sql.append("AND r2.REGION_NAME = ? ");
	    }
	    
	    if (searchCondition.getSiGun() != null && !searchCondition.getSiGun().isEmpty()) {
	        sql.append("AND r1.REGION_NAME = ? ");
	    }
	    
	    if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().isEmpty()) {
	        sql.append("AND ro.ROOM_TITLE LIKE ? ");
	    }
	    
	    try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
	        int paramIndex = 1;
	        
	        if (searchCondition.getSi() != null && !searchCondition.getSi().isEmpty()) {
	            pstmt.setString(paramIndex++, searchCondition.getSi());
	        }
	        
	        if (searchCondition.getSiGun() != null && !searchCondition.getSiGun().isEmpty()) {
	            pstmt.setString(paramIndex++, searchCondition.getSiGun());
	        }
	        
	        if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + searchCondition.getKeyword() + "%");
	        }
	        
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt(1);
	            }
	        }
	    }
	    
	    return 0;
	}
	

	public List<RegionDto> getRegion() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<RegionDto> regionList = new ArrayList<>();
	
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT region_id, region_name FROM region WHERE parent_id is NULL";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				RegionDto mainRegion = RegionDto.builder()
						.mainRegionId(rs.getInt("region_id"))
						.mainRegion(rs.getString("region_name"))
						.build();
				regionList.add(mainRegion);
				}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return regionList;
	}
	
	public List<RegionDto> getRegion(Connection conn) {
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<RegionDto> regionList = new ArrayList<>();
		
		try {
			
			String sql = "SELECT region_id, region_name FROM region WHERE parent_id is NULL";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
		
			while(rs.next()) {
			
				RegionDto mainRegion = RegionDto.builder()
						.mainRegionId(rs.getInt("region_id"))
						.mainRegion(rs.getString("region_name"))
						.build();
				regionList.add(mainRegion);
			
				}
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return regionList;
	}
	
	public int insertRoomBoard(RoomBoardDto insertRoomBoardDto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		int insertRoomBoardId = 0;
		String sql = "INSERT INTO ROOM_BOARD ( " +
	             "room_board_title, " +
	             "room_board_content, " +
	             "user_id, " +
	             "room_board_type, " +
	             "room_id " +
	             ") VALUES (?, ?, ?, ?, ?)";
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql, new String[]{"room_board_id"});
			pstmt.setString(1, insertRoomBoardDto.getRoomBoardTitle());
			pstmt.setString(2, insertRoomBoardDto.getRoomBoardContent());
			pstmt.setInt(3, insertRoomBoardDto.getUserId());
			pstmt.setString(4, insertRoomBoardDto.getRoomBoardType());
			pstmt.setInt(5, insertRoomBoardDto.getRoomId());
			
			result = pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			
	        if (rs.next()) {
	        	insertRoomBoardId = rs.getInt(1);
	        }
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return insertRoomBoardId;
		
	}
	
	
	
	public List<RegionDto> getSubRegion(int parentId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<RegionDto> regionList = new ArrayList<>();
	
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "SELECT region_id, region_name FROM region WHERE parent_id = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, parentId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				RegionDto subRegion = RegionDto.builder()
						.subRegionId(rs.getInt("region_id"))
						.subRegion(rs.getString("region_name"))
						.build();
				regionList.add(subRegion);
				}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		
		return regionList;
	}
	// ------------------------------------모임방 관리-----------------------------------------------------
	public PageResult<JoinRoomUserDto> getJoinRoomMember(int roomId, SearchCondition searchCondition) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<JoinRoomUserDto> joinRoomUserList = new ArrayList<>();
		PageResult<JoinRoomUserDto> pageResult = new PageResult<>();
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT u.USER_ID as user_id, ");
		sql.append("       jr.ROOM_ID as room_id, ");
		sql.append("       jr.ROOM_TIER as room_tier, ");
		sql.append("       u.USER_NICKNAME as user_nickname, ");
		sql.append("       u.USER_PHOTO as user_photo ");
		sql.append("FROM JOIN_ROOM jr ");
		sql.append("JOIN \"USER\" u ON u.USER_ID = jr.USER_ID ");
		sql.append("WHERE jr.ROOM_ID = ? AND u.USER_STATUS = ? ");

		if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().trim().isEmpty()) {
		    sql.append("AND u.USER_NICKNAME LIKE ? ");
		}

		sql.append("ORDER BY jr.ROOM_TIER DESC ");
		sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			int paramIndex = 1;
	        pstmt.setInt(paramIndex++, roomId);
	        pstmt.setString(paramIndex++, "ACTIVE");
	        
	        // 검색어가 있으면 파라미터 추가
	        if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().trim().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + searchCondition.getKeyword() + "%");
	        }
	        
	        pstmt.setInt(paramIndex++, searchCondition.getOffset()); // OFFSET
	        pstmt.setInt(paramIndex++, searchCondition.getSize());   // FETCH NEXT
	        
	        
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				JoinRoomUserDto joinRoomUserDto = JoinRoomUserDto.builder()
						.userId(rs.getInt("user_id"))
			            .roomId(rs.getInt("room_id"))
			            .roomTier(rs.getString("room_tier"))
			            .userNickname(rs.getString("user_nickname"))
			            .userPhoto(rs.getString("user_photo"))
			            .build();
				joinRoomUserList.add(joinRoomUserDto);
			}
			int totalCount = getJoinRoomUserCount(conn, roomId);
			int totalPages = (int) Math.ceil((double) totalCount / searchCondition.getSize());
			
			pageResult.setData(joinRoomUserList);
			pageResult.setTotalCount(totalCount);
			pageResult.setTotalPages(totalPages);
			pageResult.setPageSize(searchCondition.getSize());
			pageResult.setCurrentPage(searchCondition.getPage());
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
		return pageResult;
	}
	
	public String manageRoomMember(int roomId, int userId, String type) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		
		String sql = "";
		if(type.equals("approve")) {
			sql = approveSql();
		}else if(type.equals("kick")){
			sql = kickSql();
		}
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,userId);
			pstmt.setInt(2, roomId);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return type;
	}
	
	private String approveSql() {
		return "UPDATE JOIN_ROOM jr "
				+ "	SET jr.ROOM_TIER = 'MEMBER' "
				+ "WHERE jr.USER_ID = ? AND jr.ROOM_ID = ?";
	}
	
	private String kickSql() {
		return "DELETE FROM JOIN_ROOM jr "
				+ "WHERE jr.USER_ID = ? AND jr.ROOM_ID = ?";
	}
	
	

	
	private int getJoinRoomUserCount(Connection conn ,int roomId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int totalCount = 0;
		System.out.println("??" + roomId);
		String sql = "SELECT count(*) as count FROM JOIN_ROOM jr "
				+ "JOIN \"USER\" u ON u.USER_ID = jr.USER_ID "
				+ "	WHERE jr.ROOM_ID = ? AND u.USER_STATUS = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, roomId);
			pstmt.setString(2, "ACTIVE");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				totalCount = rs.getInt("count");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
		}
		
		return totalCount;
	}
	
	
	public Map<String, Object> findMyRoomCards(int userId, int offset, int limit) throws Exception {
        // hasMore 판단하려면 fetch = limit + 1 로 가져온 후 초과 여부로 표시
        int fetch = limit + 1;

        String sql =
            "SELECT r.room_id, r.room_title, r.room_thumbnail, r.created_at, " +
            "       r1.region_name AS child_region, r2.region_name AS parent_region, " +
            "       cm.jmName, " +
            "       (SELECT COUNT(*) FROM JOIN_ROOM jx WHERE jx.room_id = r.room_id) AS member_count, " +
            "       (SELECT COUNT(*) FROM LIKE_ROOM lx WHERE lx.room_id = r.room_id) AS like_count " +
            "FROM ROOM r " +
            "JOIN JOIN_ROOM jr ON jr.room_id = r.room_id AND jr.user_id = ? " +
            "JOIN REGION r1 ON r1.region_id = r.region_id " +
            "LEFT JOIN REGION r2 ON r2.region_id = r1.parent_id " +
            "JOIN CERTIFICATION_MASTER cm " +
            "  ON cm.jmcd = r.jmcd AND cm.year = r.year AND cm.implSeq = r.implSeq " +
            "WHERE r.is_deleted = 'N' " +
            "ORDER BY r.created_at DESC, r.room_id DESC " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
        boolean hasMore = false;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConnectionPoolHelper.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, fetch);

            rs = ps.executeQuery();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");

            while (rs.next()) {
                if (items.size() == limit) { // 초과 한 개는 hasMore 판단용
                    hasMore = true;
                    break;
                }
                Map<String, Object> m = new HashMap<String, Object>();
                int roomId = rs.getInt("room_id");
                m.put("roomId", Integer.valueOf(roomId));
                m.put("title", rs.getString("room_title"));
                m.put("thumbUrl", rs.getString("room_thumbnail"));
                m.put("parentRegion", rs.getString("parent_region")); // 예: 서울시
                m.put("childRegion", rs.getString("child_region"));   // 예: 강남구
                m.put("certName", rs.getString("jmName"));            // 예: 정보처리기사
                Timestamp ts = rs.getTimestamp("created_at");
                m.put("date", ts != null ? sdf.format(ts) : "");
                m.put("memberCount", Integer.valueOf(rs.getInt("member_count")));
                m.put("likeCount", Integer.valueOf(rs.getInt("like_count")));
                items.add(m);
            }
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(ps);
            ConnectionPoolHelper.close(conn);
        }

        Map<String, Object> res = new HashMap<String, Object>();
        res.put("items", items);
        res.put("hasMore", Boolean.valueOf(hasMore));
        return res;
    }
	


	public List<Map<String, Object>> findRecentPostsByUser(int userId, int limit) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            "SELECT rb.ROOM_BOARD_ID, " +
            "       rb.ROOM_BOARD_TITLE, " +
            "       rb.CREATED_AT, " +
            "       rb.ROOM_BOARD_VIEW_CNT, " +
            "       r.ROOM_ID, " +
            "       r.ROOM_TITLE, " +
            "       (SELECT COUNT(*) " +
            "          FROM \"REPLY\" rp " +
            "         WHERE rp.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
            "           AND rp.PARENT_REPLY_ID IS NULL) AS REPLY_COUNT " +
            "  FROM ROOM_BOARD rb " +
            "  JOIN \"ROOM\" r ON r.ROOM_ID = rb.ROOM_ID " +
            " WHERE rb.USER_ID = ? " +
            "   AND rb.IS_DELETED = 'N' " +
            " ORDER BY rb.CREATED_AT DESC, rb.ROOM_BOARD_ID DESC " +
            " FETCH FIRST ? ROWS ONLY";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, (limit <= 0 ? 10 : limit));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new LinkedHashMap<>();
                    int boardId = rs.getInt("ROOM_BOARD_ID");

                    m.put("id", boardId);
                    m.put("title", rs.getString("ROOM_BOARD_TITLE"));
                    m.put("createdAt", rs.getTimestamp("CREATED_AT"));
                    m.put("viewCount", rs.getInt("ROOM_BOARD_VIEW_CNT"));
                    m.put("replyCount", rs.getInt("REPLY_COUNT"));

                    m.put("roomId", rs.getInt("ROOM_ID"));
                    m.put("roomTitle", rs.getString("ROOM_TITLE"));

                    // (선택) 서블릿이 없으면 만들어주는 기본 URL
                    m.put("url", "/room/board/detail?roomBoardId=" + boardId);

                    list.add(m);
                }
            }
        }
        return list;
    }
	

}
