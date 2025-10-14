package kr.or.kosa.dao;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.RoomBoardDto;
import kr.or.kosa.dto.RoomDto;
import kr.or.kosa.dto.SearchCondition;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
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
					+ "VALUES (11, ?, 'LEADER')";
			
			pstmt2 = conn.prepareStatement(sql2);
			pstmt2.setInt(1, generatedRoomId);
			
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
	        sql.append("  (SELECT COUNT(*) FROM JOIN_ROOM jr WHERE jr.ROOM_ID = ro.ROOM_ID) AS participant_count, ");
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
	        sql.append("LEFT JOIN LIKE_ROOM lr ON lr.ROOM_ID = ro.ROOM_ID AND lr.USER_ID = 1");
	        sql.append("WHERE 1=1 ");
	        sql.append("AND is_deleted = 'N' ");
	        // 서울시 이런식으로 있다면
	        if (searchCondition.getSi() != null && !searchCondition.getSi().isEmpty()) {
	            sql.append("AND r2.REGION_NAME = ? ");
	        }
	        // ~구가 있다면
	        if (searchCondition.getSiGun() != null && !searchCondition.getSiGun().isEmpty()) {
	            sql.append("AND r1.REGION_NAME = ? ");
	        }
	        // 검색어가 있다면
	        if (searchCondition.getKeyword() != null && !searchCondition.getKeyword().isEmpty()) {
	            sql.append("AND ro.ROOM_TITLE LIKE ? ");
	        }
	        sql.append("ORDER BY ro.ROOM_ID DESC ");
	        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
			pstmt = conn.prepareStatement(sql.toString());
			
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
		
		return pageResult;
		
	}
	
	public RoomDto detialRoom(int roomId) {
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
			int userId = 5;
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId); // 현재 접속 유저 아이디
			pstmt.setInt(2, userId); // 현재 접속 유저 아이디
			pstmt.setInt(3, userId);
			pstmt.setInt(4, roomId);
			pstmt.setInt(5, roomId); // 현재 접속 유저 아이디
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				System.out.println("islIke ==>> " + (rs.getInt("is_liked") == 1));
				System.out.println("leader_check ==>> " + (rs.getInt("leader_check") == 1));
				System.out.println("asdasdas ==>>> " + rs.getInt("leader_check"));
				
				
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
				
				try {
						roomDetail.isLiked();
						
					
				}catch(Exception e) {
					
					System.out.println("isLiked() ==>> ?? " + roomDetail.isLiked());
					System.out.println(" ==>> " + (rs.getInt("is_liked")));
					System.out.println(" ==>> " + (rs.getInt("is_liked") == 1));
				}
					
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
	
	// 룸보드 게시판 검색
	public List<RoomBoardDto> getRoomBoardBySearch(SearchCondition searchCondition) {
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
		.append("WHERE ROOM_BOARD_TYPE = 'GENERAL' ");
		
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
				
				System.out.println(" ??? 타이들인데?? +===>>> " + roomBoard.getRoomBoardTitle());
				roomBoardList.add(roomBoard);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return roomBoardList;
	}
	
	public RoomBoardDto getRoomBoardDetail(int roomBoardId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int userId = 13;
		RoomBoardDto roomBoard = null;
		
//		String sql = """
//			    SELECT 
//			    	rb.ROOM_BOARD_ID as ROOM_BOARD_ID,
//			        rb.ROOM_BOARD_TITLE as ROOM_BOARD_TITLE,  
//			        rb.ROOM_BOARD_CONTENT as ROOM_BOARD_CONTENT, 
//			        rb.UPDATED_AT as UPDATED_AT, 
//			        rb.ROOM_BOARD_VIEW_CNT as ROOM_BOARD_VIEW_CNT,
//			        u.USER_PHOTO as USER_PHOTO, 
//			        (SELECT COUNT(*) 
//			         FROM LIKE_ROOM_BOARD 
//			         WHERE ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS like_count,
//			        NVL(lrb.USER_ID, 0) AS like_status,
//			        (SELECT CASE 
//			             WHEN rb.USER_ID = ? THEN 1 
//			             ELSE 0 
//			         END 
//			         FROM DUAL) AS is_my_post
//			    FROM ROOM_BOARD rb
//			    JOIN "USER" u ON u.USER_ID = rb.USER_ID
//			    LEFT JOIN LIKE_ROOM_BOARD lrb 
//			        ON lrb.USER_ID = ? 
//			        AND lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID
//			    WHERE rb.ROOM_BOARD_ID = ?
//			    """;
		String sql = "SELECT " +
			    "rb.ROOM_BOARD_ID as ROOM_BOARD_ID, " +
			    "rb.ROOM_BOARD_TITLE as ROOM_BOARD_TITLE, " +
			    "rb.ROOM_BOARD_CONTENT as ROOM_BOARD_CONTENT, " +
			    "rb.UPDATED_AT as UPDATED_AT, " +
			    "rb.ROOM_BOARD_VIEW_CNT as ROOM_BOARD_VIEW_CNT, " +
			    "u.USER_PHOTO as USER_PHOTO, " +
			    "(SELECT COUNT(*) FROM LIKE_ROOM_BOARD WHERE ROOM_BOARD_ID = rb.ROOM_BOARD_ID) AS like_count, " +
			    "NVL(lrb.USER_ID, 0) AS like_status, " +
			    "CASE WHEN rb.USER_ID = ? THEN 1 ELSE 0 END AS is_my_post " +
			    "FROM ROOM_BOARD rb " +
			    "JOIN \"USER\" u ON u.USER_ID = rb.USER_ID " +
			    "LEFT JOIN LIKE_ROOM_BOARD lrb ON lrb.USER_ID = ? AND lrb.ROOM_BOARD_ID = rb.ROOM_BOARD_ID " +
			    "WHERE rb.ROOM_BOARD_ID = ?";
		
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
		}
		return roomBoard;
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
	

}
