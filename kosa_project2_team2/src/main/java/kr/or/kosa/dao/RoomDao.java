package kr.or.kosa.dao;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import kr.or.kosa.dto.PageResult;
import kr.or.kosa.dto.RegionDto;
import kr.or.kosa.dto.RoomDto;
import kr.or.kosa.dto.SearchCondition;
import kr.or.kosa.utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;





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
					+ "VALUES (1, ?, '방장')";
			
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
				RoomDto room = RoomDto.builder()
		                .roomId(rs.getInt("room_id"))
		                .title(rs.getString("room_title"))
		                .thumbnailUrl(rs.getString("room_thumbnail"))
		                .maxParticipant(rs.getInt("max_participant"))
		                .roomStatus(rs.getString("room_status"))
		                .parentRegion(rs.getString("parent_region"))
		                .childRegion(rs.getString("child_region"))
		                .participantCount(rs.getInt("participant_count"))
		                .likeCount(rs.getInt("like_count"))
		                .certName(rs.getString("cert_name"))
		                .isLiked(rs.getBoolean("is_liked"))
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
	
	public void detialRoom(int roomId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = ConnectionPoolHelper.getConnection();
			String sql = "";
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
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
	
	
	

}
