package kr.or.kosa.dao;


import kr.or.kosa.dto.JoinRoomUserDto;
import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.RoomBoardDto;
import kr.or.kosa.dto.RoomDto;
import kr.or.kosa.dto.SearchCertificateDto;
import kr.or.kosa.dto.SearchCondition;
import kr.or.kosa.dto.user.MyPostItem;
import kr.or.kosa.dto.user.RoomCardDto;
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
	        pstmt.setInt(6, insertRoomDto.getJmcd());
	        pstmt.setInt(7, insertRoomDto.getYear()); 
	        pstmt.setInt(8, insertRoomDto.getImplseq());
	        
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
	
	public PageResult<RoomDto> getRoomsBySearch(SearchCondition searchCondition, int userId){
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
	        sql.append("LEFT JOIN LIKE_ROOM lr ON lr.ROOM_ID = ro.ROOM_ID AND lr.USER_ID = ? ");
	        sql.append("WHERE 1=1 ");
	        sql.append("AND ro.is_deleted = 'N' ");
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
			
			int paramIndex = 1;
			pstmt.setInt(paramIndex++, userId); // 이거는 유저아이디가 들어간다.
			
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
	        System.out.println("totalPages =>> " + totalPages);
	        System.out.println("totalCount =>> " + totalCount);
	        
	        
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
	
	public RoomDto updateInfoRoom(int roomId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RoomDto updateInfo = null;
		
		String sql = "SELECT ro.ROOM_ID as ROOM_ID, "
					+ "ro.ROOM_TITLE as ROOM_TITLE, "
					+ "ro.ROOM_CONTENT as ROOM_CONTENT, "
					+ "ro.ROOM_THUMBNAIL as ROOM_THUMBNAIL, "
		           + "ro.MAXPARTICIPANT as MAXPARTICIPANT, "
		           + "ro.ROOM_STATUS as ROOM_STATUS, "
		           + "r1.REGION_ID as SUB_REGION_ID, "
		           + "r1.REGION_NAME as SUB_REGION_NAME, "
		           + "r2.REGION_ID as MAIN_REGION_ID, "
		           + "r2.REGION_NAME as MAIN_REGION_NAME, "
		           + "cm.JMCD as JMCD,"
		           + "cm.JMNAME as JMNAME, "
		           + "cm.IMPLSEQ as IMPLSEQ, "
		           + "cm.\"YEAR\" as YEAR, "
		           + "cs.EXAMGB as EXAMGB "
		           + "FROM ROOM ro "
		           + "JOIN REGION r1 ON ro.REGION_ID = r1.REGION_ID "
		           + "JOIN REGION r2 ON r2.REGION_ID = r1.PARENT_ID "
		           + "JOIN CERTIFICATION_MASTER cm ON cm.JMCD = ro.JMCD AND cm.\"YEAR\" = ro.\"YEAR\" AND cm.IMPLSEQ = ro.IMPLSEQ "
		           + "JOIN CERTIFICATION_STATS cs ON cs.JMCD = ro.JMCD AND cs.\"YEAR\" = ro.\"YEAR\" AND cs.IMPLSEQ = ro.IMPLSEQ  "
		           + "WHERE ro.ROOM_ID = ?";
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, roomId);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				updateInfo = RoomDto.builder()
			        .roomId(rs.getInt("ROOM_ID"))
			        .title(rs.getString("ROOM_TITLE"))
			        .content(rs.getString("ROOM_CONTENT"))
			        .thumbnailUrl(rs.getString("ROOM_THUMBNAIL"))
			        .maxParticipant(rs.getInt("MAXPARTICIPANT"))
			        .roomStatus(rs.getString("ROOM_STATUS"))
			        .subRegionId(rs.getInt("SUB_REGION_ID"))
			        .childRegion(rs.getString("SUB_REGION_NAME"))
			        .regionId(rs.getInt("MAIN_REGION_ID"))
			        .parentRegion(rs.getString("MAIN_REGION_NAME"))
			        .jmcd(rs.getInt("JMCD"))
			        .examgb(rs.getString("EXAMGB"))
			        .totalJmName(rs.getInt("YEAR") +"년 " +rs.getInt("IMPLSEQ")+"회차 " + rs.getString("JMNAME"))
			        .implseq(rs.getInt("IMPLSEQ"))
			        .year(rs.getInt("YEAR"))
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
		return updateInfo;
	}
	
	public int updateRoom(RoomDto updateRoom) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		RoomDto resultRoom = null;
		System.out.println("?? ==>> " + updateRoom);
		
		String sql = "UPDATE ROOM SET " +
	             "room_title = ?, " +
	             "room_content = ?, " +
	             "room_thumbnail = ?, " +
	             "maxParticipant = ?, " +
	             "region_id = ?, " +
	             "jmcd = ?, " +
	             "year = ?, " +
	             "implSeq = ?, " +
	             "updated_at = SYSDATE " +
	             "WHERE room_id = ?";
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, updateRoom.getTitle());
			pstmt.setString(2, updateRoom.getContent());
			pstmt.setString(3, updateRoom.getThumbnailUrl());
			pstmt.setInt(4, updateRoom.getMaxParticipant());
			pstmt.setInt(5, updateRoom.getSubRegionId());
			pstmt.setInt(6, updateRoom.getJmcd());
			pstmt.setInt(7, updateRoom.getYear());
			pstmt.setInt(8, updateRoom.getImplseq());
			pstmt.setInt(9, updateRoom.getRoomId()); // 업데이트할 방의 ID
			result = pstmt.executeUpdate();
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(pstmt);
			ConnectionPoolHelper.close(conn);
		}
		return result;
	}
	
	
	public RoomDto detialRoom(int roomId, int userId) {
		Connection conn = null;
		RoomDto roomDetail = null;
		
		StringBuilder sqlBuilder = new StringBuilder();
		try {
			conn  = ConnectionPoolHelper.getConnection();
			if(userId != 0) {
				roomDetail = detailRoomWithUser(roomId, userId, conn);
			}else {
				roomDetail = detailWithoutUser(roomId, conn);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(conn);
		}
		return roomDetail;
	}
	
	
	private RoomDto detailRoomWithUser(int roomId, int userId, Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RoomDto roomDetail = null;
		
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
			
		try {
			String sql = sqlBuilder.toString();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId); // 현재 접속 유저 아이디
			pstmt.setInt(2, userId); // 현재 접속 유저 아이디
			pstmt.setInt(3, userId);
			pstmt.setInt(4, roomId);
			pstmt.setInt(5, roomId);
			
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
		}
		return roomDetail;
	}
	
	private RoomDto detailWithoutUser(int roomId, Connection conn) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		RoomDto roomDto = null;
		
		StringBuilder sqlBuilder = new StringBuilder();
		
		sqlBuilder.append("SELECT ");
		sqlBuilder.append(" ro.room_id, ");
		sqlBuilder.append(" ro.room_title, ");
		sqlBuilder.append(" ro.room_content, ");
		sqlBuilder.append(" ro.updated_at, ");
		sqlBuilder.append(" u.user_nickname, ");
		sqlBuilder.append(" (SELECT COUNT(*) ");
		sqlBuilder.append("  FROM LIKE_ROOM lr ");
		sqlBuilder.append("  WHERE lr.room_id = ro.room_id) AS like_count, ");
		sqlBuilder.append(" (SELECT CASE ");
		sqlBuilder.append("  WHEN ROUND(AVG(score), 1) IS NOT NULL ");
		sqlBuilder.append("  THEN ROUND(AVG(score), 1) ");
		sqlBuilder.append("  ELSE 0 ");
		sqlBuilder.append("  END ");
		sqlBuilder.append("  FROM ROOM_SCORE rs ");
		sqlBuilder.append("  WHERE rs.room_id = ro.room_id) AS room_score ");
		sqlBuilder.append("FROM room ro ");
		sqlBuilder.append("JOIN JOIN_ROOM jr ");
		sqlBuilder.append(" ON jr.room_id = ro.room_id ");
		sqlBuilder.append("JOIN \"USER\" u ");
		sqlBuilder.append(" ON u.user_id = jr.user_id ");
		sqlBuilder.append("WHERE ro.room_id = ? ");
		sqlBuilder.append(" AND jr.room_tier = 'LEADER'");

		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sqlBuilder.toString());
			pstmt.setInt(1, roomId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				roomDto = RoomDto.builder()
			        .roomId(rs.getInt("room_id"))
			        .title(rs.getString("room_title"))
			        .content(rs.getString("room_content"))
			        .updatedAt(rs.getDate("updated_at"))  // Date 타입이면 getTimestamp 사용
			        .userNickName(rs.getString("user_nickname"))
			        .likeCount(rs.getInt("like_count"))
			        .roomScore(rs.getDouble("room_score"))
			        .build();
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt);
		}
		return roomDto;
		
		
	}
	
	// 모임방 삭제
	public int deleteRoom(int roomId, int userId) {
		Connection conn = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int result = 0;
		
		String checkSql = "SELECT ROOM_TIER  FROM JOIN_ROOM "
				+ "WHERE USER_ID = ? AND ROOM_ID = ?";
		
		String deleteSql = "UPDATE ROOM "
				+ "SET IS_DELETED = 'Y' "
				+ "WHERE ROOM_ID = ?";
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt1 = conn.prepareStatement(checkSql);
			pstmt1.setInt(1, userId);
			pstmt1.setInt(2, roomId);
			
			rs = pstmt1.executeQuery();
			String tierCheck = "";
			while(rs.next()) {
				tierCheck = rs.getString("ROOM_TIER");
			}
			if(!tierCheck.isEmpty() && tierCheck.equals("LEADER")) {
				pstmt2 = conn.prepareStatement(deleteSql);
				pstmt2.setInt(1, roomId);
				result = pstmt2.executeUpdate();
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			ConnectionPoolHelper.close(rs);
			ConnectionPoolHelper.close(pstmt2);
			ConnectionPoolHelper.close(pstmt1);
			ConnectionPoolHelper.close(conn);
		}
		return result;
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
	    sql.append("WHERE 1=1 AND ro.is_deleted = 'N' ");
	    
	    if (searchCondition.getSi() != null && !searchCondition.getSi().isEmpty()) {
            sql.append("AND r2.REGION_ID = ? ");
        }
        // ~구가 있다면
        if (searchCondition.getSiGun() != null && !searchCondition.getSiGun().isEmpty()) {
            sql.append("AND r1.REGION_ID = ? ");
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
		}finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
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
	
	public int countMyRooms(long userId, String tab, String q) {
	    StringBuilder sql = new StringBuilder();
	    sql.append("SELECT COUNT(*) ")
	       .append(" FROM ROOM r ")
	       .append(" JOIN JOIN_ROOM jr ON jr.room_id = r.room_id ")
	       .append(" JOIN CERTIFICATION_MASTER cm ON cm.jmcd=r.jmcd AND cm.year=r.year AND cm.implSeq=r.implSeq ")
	       .append(" WHERE r.is_deleted='N' AND jr.user_id=? ");
	    if ("hosted".equalsIgnoreCase(tab)) {
	      sql.append(" AND jr.room_tier='LEADER' ");
	    }
	    if (q != null && !q.isBlank()) {
	      sql.append(" AND (LOWER(r.room_title) LIKE LOWER(?) OR LOWER(cm.jmName) LIKE LOWER(?)) ");
	    }

	    try (Connection conn = ConnectionPoolHelper.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	      int i=1;
	      ps.setLong(i++, userId);
	      if (q != null && !q.isBlank()) {
	        String like = "%"+q+"%";
	        ps.setString(i++, like);
	        ps.setString(i++, like);
	      }
	      try (ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) return rs.getInt(1);
	      }
	    } catch (Exception e) { e.printStackTrace(); }
	    return 0;
	  }

	  /* 목록 */
	  public List<RoomCardDto> findMyRooms(long userId, String tab, String q, String sort, int size, int page) {
	    List<RoomCardDto> list = new ArrayList<>();
	    String order;
	    switch (sort==null? "recent" : sort) {
	      case "popular": order = " like_cnt DESC, r.updated_at DESC "; break;
	      case "old":     order = " r.updated_at ASC "; break;
	      default:        order = " r.updated_at DESC ";
	    }

	    // Oracle 12c+ OFFSET 사용 (11g면 ROWNUM 래핑으로 교체)
	    StringBuilder sql = new StringBuilder();
	    sql.append("SELECT * FROM ( ")
	       .append("  SELECT r.room_id, r.room_title, r.room_thumbnail, r.maxParticipant, r.room_status, ")
	       .append("         TO_CHAR(r.updated_at, 'YYYY.MM.DD') AS updated_fmt, ")
	       .append("         cm.jmName, ")
	       .append("         pr.region_name AS parent_region, cr.region_name AS child_region, ")
	       .append("         (SELECT COUNT(*) FROM JOIN_ROOM j2 WHERE j2.room_id=r.room_id) AS member_cnt, ")
	       .append("         (SELECT COUNT(*) FROM LIKE_ROOM l2 WHERE l2.room_id=r.room_id) AS like_cnt, ")
	       .append("         CASE WHEN EXISTS (SELECT 1 FROM LIKE_ROOM l3 WHERE l3.user_id=? AND l3.room_id=r.room_id) THEN 1 ELSE 0 END AS liked ")
	       .append("    FROM ROOM r ")
	       .append("    JOIN JOIN_ROOM jr ON jr.room_id=r.room_id ")
	       .append("    JOIN CERTIFICATION_MASTER cm ON cm.jmcd=r.jmcd AND cm.year=r.year AND cm.implSeq=r.implSeq ")
	       .append("    JOIN region cr ON cr.region_id = r.region_id ")
	       .append("    LEFT JOIN region pr ON pr.region_id = cr.parent_id ")
	       .append("   WHERE r.is_deleted='N' AND jr.user_id=? ");

	    if ("hosted".equalsIgnoreCase(tab)) {
	      sql.append(" AND jr.room_tier='LEADER' ");
	    }
	    if (q != null && !q.isBlank()) {
	      sql.append(" AND (LOWER(r.room_title) LIKE LOWER(?) OR LOWER(cm.jmName) LIKE LOWER(?)) ");
	    }
	    sql.append("   ORDER BY ").append(order)
	       .append(") ")
	       .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

	    try (Connection conn = ConnectionPoolHelper.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	      int i=1;
	      ps.setLong(i++, userId);  // liked 체크
	      ps.setLong(i++, userId);  // 내 방 조건
	      if (q != null && !q.isBlank()) {
	        String like = "%"+q+"%";
	        ps.setString(i++, like);
	        ps.setString(i++, like);
	      }
	      ps.setInt(i++, (page-1)*size);
	      ps.setInt(i++, size);

	      try (ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) {
	          list.add(RoomCardDto.builder()
	              .roomId(rs.getLong("room_id"))
	              .title(rs.getString("room_title"))
	              .thumbnailUrl(nvl(rs.getString("room_thumbnail"), ""))
	              .maxParticipant(rs.getInt("maxParticipant"))
	              .status(rs.getString("room_status"))
	              .updatedAt(rs.getString("updated_fmt"))
	              .certName(rs.getString("jmName"))
	              .parentRegion(nvl(rs.getString("parent_region"), ""))
	              .childRegion(nvl(rs.getString("child_region"), ""))
	              .participantCount(rs.getInt("member_cnt"))
	              .likeCount(rs.getInt("like_cnt"))
	              .liked(rs.getInt("liked")==1)
	              .build());
	        }
	      }
	    } catch (Exception e) { e.printStackTrace(); }
	    return list;
	  }

	  public boolean toggleLike(long userId, long roomId, boolean isLiked) {
	    String del = "DELETE FROM LIKE_ROOM WHERE user_id=? AND room_id=?";
	    String ins = "INSERT INTO LIKE_ROOM(user_id, room_id) VALUES(?, ?)";
	    try (Connection conn = ConnectionPoolHelper.getConnection()) {
	      conn.setAutoCommit(false);
	      try (PreparedStatement ps = conn.prepareStatement(isLiked ? ins : del)) {
	        ps.setLong(1, userId);
	        ps.setLong(2, roomId);
	        int n = ps.executeUpdate();
	        conn.commit();
	        return n>0;
	      } catch(Exception e){
	        conn.rollback();
	        throw e;
	      } finally { conn.setAutoCommit(true); }
	    } catch (Exception e) {
	      e.printStackTrace();
	      return false;
	    }
	  }
	  
	  
	  // 1) 총개수
	    public int countMyPosts(long userId, String q) {
	        StringBuilder sql = new StringBuilder();
	        sql.append("SELECT COUNT(*) ")
	           .append("  FROM ROOM_BOARD rb ")
	           .append("  JOIN ROOM ro ON ro.ROOM_ID = rb.ROOM_ID ")
	           .append("  JOIN CERTIFICATION_MASTER cm ")
	           .append("    ON cm.JMCD = ro.JMCD AND cm.YEAR = ro.YEAR AND cm.IMPLSEQ = ro.IMPLSEQ ")
	           .append(" WHERE rb.USER_ID = ? ")
	           .append("   AND NVL(rb.IS_DELETED,'N')='N' ")
	           .append("   AND NVL(ro.IS_DELETED,'N')='N' ");
	        // ★ 제목만 검색
	        if (q != null && !q.isBlank()) {
	            sql.append(" AND LOWER(rb.ROOM_BOARD_TITLE) LIKE LOWER(?) ");
	        }

	        try (Connection conn = ConnectionPoolHelper.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	            int i = 1;
	            ps.setLong(i++, userId);
	            if (q != null && !q.isBlank()) {
	                ps.setString(i++, "%" + q.trim() + "%");
	            }
	            try (ResultSet rs = ps.executeQuery()) {
	                if (rs.next()) return rs.getInt(1);
	            }
	        } catch (Exception e) { e.printStackTrace(); }
	        return 0;
	    }

	 // 2) 목록
	    public List<kr.or.kosa.dto.user.MyPostSummaryDto> findMyPosts(
	            long userId, String q, String sort, int size, int page) {

	        List<kr.or.kosa.dto.user.MyPostSummaryDto> list = new ArrayList<>();
	        String order = " rb.CREATED_AT DESC, rb.ROOM_BOARD_ID DESC ";
	        if ("old".equalsIgnoreCase(sort)) order = " rb.CREATED_AT ASC, rb.ROOM_BOARD_ID ASC ";

	        StringBuilder sql = new StringBuilder();
	        sql.append("SELECT * FROM ( ")
	           .append("  SELECT rb.ROOM_BOARD_ID AS board_id, ")
	           .append("         rb.ROOM_BOARD_TITLE AS title, ")
	           .append("         cm.JMNAME AS category, ")
	           .append("         rb.ROOM_BOARD_VIEW_CNT AS view_cnt, ")
	           .append("         TO_CHAR(rb.CREATED_AT,'YYYY.MM.DD') AS created_fmt, ")
	           // ★ 테이블명이 LIKE_ROOM_BOARD 인 점 반영
	           .append("         (SELECT COUNT(*) FROM LIKE_ROOM_BOARD l ")
	           .append("           WHERE l.ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS like_cnt ")
	           .append("    FROM ROOM_BOARD rb ")
	           .append("    JOIN ROOM ro ON ro.ROOM_ID = rb.ROOM_ID ")
	           .append("    JOIN CERTIFICATION_MASTER cm ")
	           .append("      ON cm.JMCD=ro.JMCD AND cm.YEAR=ro.YEAR AND cm.IMPLSEQ=ro.IMPLSEQ ")
	           .append("   WHERE rb.USER_ID=? ")
	           .append("     AND NVL(rb.IS_DELETED,'N')='N' ")
	           .append("     AND NVL(ro.IS_DELETED,'N')='N' ");
	        // ★ 제목만 검색
	        if (q != null && !q.isBlank()) {
	            sql.append(" AND LOWER(rb.ROOM_BOARD_TITLE) LIKE LOWER(?) ");
	        }
	        sql.append("   ORDER BY ").append(order)
	           .append(") OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

	        try (Connection conn = ConnectionPoolHelper.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	            int i=1;
	            ps.setLong(i++, userId);
	            if (q != null && !q.isBlank()) {
	                ps.setString(i++, "%" + q.trim() + "%");
	            }
	            ps.setInt(i++, (page-1)*size);
	            ps.setInt(i++, size);

	            try (ResultSet rs = ps.executeQuery()) {
	                while (rs.next()) {
	                    list.add(kr.or.kosa.dto.user.MyPostSummaryDto.builder()
	                        .boardId(rs.getLong("board_id"))
	                        .boardTitle(rs.getString("title"))
	                        .category(rs.getString("category"))   // cm.jmName
	                        .likeCount(rs.getInt("like_cnt"))
	                        .viewCount(rs.getInt("view_cnt"))
	                        .createdAt(rs.getString("created_fmt"))
	                        .build());
	                }
	            }
	        } catch (Exception e) { e.printStackTrace(); }
	        return list;
	    }
	  

	  private static String nvl(String s, String d){ return (s==null)? d : s; }
	  
	  public List<SearchCertificateDto> searchcertificate(String keyword, String examType) {
		  Connection conn = null;
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
		  List<SearchCertificateDto> searchcertificateList = new ArrayList<>();
		  
		  StringBuilder sql = new StringBuilder();
		  sql.append("SELECT cm.JMCD as JMCD, cm.\"YEAR\" as YEAR, cm.IMPLSEQ as IMPLSEQ, cm.JMNAME as JMNAME FROM CERTIFICATION_MASTER cm ");
		  sql.append("JOIN CERTIFICATION_SCHEDULE cs ON cs.JMCD = cm.JMCD AND cs.\"YEAR\" = cm.\"YEAR\" AND cs.IMPLSEQ = cm.IMPLSEQ ");
		  sql.append("JOIN CERTIFICATION_STATS cs2 ON cs2.JMCD = cm.JMCD AND cs2.\"YEAR\" = cm.\"YEAR\" AND cs2.IMPLSEQ = cm.IMPLSEQ ");
		  sql.append("WHERE 1=1 ");

		  // 필기/실기 조건
		  if (examType != null && !examType.isEmpty()) {
		      sql.append("AND cs2.EXAMGB = ? ");
		      
		      if ("필기".equals(examType)) {
		          sql.append("AND cs.docRegStartDt >= SYSDATE ");
		      } else if ("실기".equals(examType)) {
		          sql.append("AND cs.pracRegStartDt >= SYSDATE ");
		      }
		  }

		  // 자격증명 검색
		  if (keyword != null && !keyword.isEmpty()) {
		      sql.append("AND cm.JMNAME LIKE ? ");
		  }

		  // 정렬
		  if ("필기".equals(examType)) {
		      sql.append("ORDER BY cs.docRegStartDt ASC");
		  } else if ("실기".equals(examType)) {
		      sql.append("ORDER BY cs.pracRegStartDt ASC");
		  }
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, examType);
			pstmt.setString(2, "%" + keyword + "%");
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				SearchCertificateDto searchCertificate = SearchCertificateDto.builder()
				        .jmcd(rs.getInt("JMCD"))
				        .year(rs.getInt("YEAR"))
				        .implseq(rs.getInt("IMPLSEQ"))
				        .jmName("JMNAME")
				        .totalJmName(rs.getInt("YEAR") +"년 " +rs.getInt("IMPLSEQ")+"회차 " + rs.getString("JMNAME"))
				        .build();
				
				searchcertificateList.add(searchCertificate);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }
		return searchcertificateList;
	  }
	  
	  public void getRoomCertificate(int roomId) {
		  Connection conn = null;
		  PreparedStatement pstmt = null;
		  ResultSet rs = null;
//		  SearchCertificateDto searchC
		  
		  
		  String sql = "SELECT cm.JMNAME, " +
		             "       cm.\"YEAR\", " +
		             "       cm.IMPLSEQ, " +
		             "       cs.DOCREGSTARTDT, " +
		             "       cs.DOCREGENDDT, " +
		             "       cs.DOCEXAMSTARTDT, " +
		             "       cs.DOCEXAMENDDT, " +
		             "       cs.DOCEXAMDT, " +
		             "       cs.DOCPASSDT, " +
		             "       cs.PRACREGSTARTDT, " +
		             "       cs.PRACREGENDDT, " +
		             "       cs.PRACEXAMSTARTDT, " +
		             "       cs.PRACEXAMENDDT, " +
		             "       cs.PRACPASSDT " +
		             "FROM ROOM ro " +
		             "JOIN CERTIFICATION_SCHEDULE cs ON cs.JMCD = ro.JMCD " +
		             "    AND cs.\"YEAR\" = ro.\"YEAR\" " +
		             "    AND cs.IMPLSEQ = ro.IMPLSEQ " +
		             "JOIN CERTIFICATION_MASTER cm ON cm.JMCD = ro.JMCD " +
		             "    AND cm.\"YEAR\" = ro.\"YEAR\" " +
		             "    AND cm.IMPLSEQ = ro.IMPLSEQ " +
		             "WHERE ro.ROOM_ID = ?";
		  
		 try {
			conn = ConnectionPoolHelper.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, roomId);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()) {
				SearchCertificateDto.builder()
	            .jmcd(rs.getInt("JMCD"))
	            .implseq(rs.getInt("IMPLSEQ"))
	            .year(rs.getInt("YEAR"))
	            .jmName(rs.getString("JMNAME"))
	            .totalJmName(rs.getString("TOTALJMNAME")) // 만약 이 컬럼이 없으면 제거
	            .docRegStartDt(rs.getDate("DOCREGSTARTDT"))
	            .docRegEndDt(rs.getDate("DOCREGENDDT"))
	            .docExamStartDt(rs.getDate("DOCEXAMSTARTDT"))
	            .docExamEndDt(rs.getDate("DOCEXAMENDDT"))
	            .docExamDt(rs.getDate("DOCEXAMDT"))
	            .docPassDt(rs.getDate("DOCPASSDT"))
	            .pracRegStartDt(rs.getDate("PRACREGSTARTDT"))
	            .pracRegEndDt(rs.getDate("PRACREGENDDT"))
	            .pracExamStartDt(rs.getDate("PRACEXAMSTARTDT"))
	            .pracExamEndDt(rs.getDate("PRACEXAMENDDT"))
	            .pracPassDt(rs.getDate("PRACPASSDT"))
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
		  
	  }
	  
}
