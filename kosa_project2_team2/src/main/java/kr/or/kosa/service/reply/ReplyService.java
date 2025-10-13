package kr.or.kosa.service.reply;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.kosa.dao.ReplyDao;
import kr.or.kosa.dto.ReplyDto;

public class ReplyService {
	
	private ReplyDao replyDao;
	
	public ReplyService() {
		this.replyDao = new ReplyDao();
	}
	
	/**
	 * 1. 댓글 작성
	 */
	public boolean writeReply(ReplyDto reply) {
		// 유효성 검증
		if (reply.getReplyContent() == null || reply.getReplyContent().trim().isEmpty()) {
			return false;
		}
		
		if (reply.getReplyContent().length() > 1000) {
			return false;
		}
		
		int result = replyDao.insertReply(reply);
		return result > 0;
	}
	
	/**
	 * 2. 댓글 목록 조회 (계층 구조 포함)
	 */
	public List<ReplyDto> getReplyList(Long roomBoardId, String orderBy, Long currentUserId) {
		List<ReplyDto> allReplies = replyDao.replyListByRoomBoardId(roomBoardId, orderBy);
		
		if (allReplies == null || allReplies.isEmpty()) {
			return new ArrayList<>();
		}
		
		// 각 댓글에 추가 정보 설정
		for (ReplyDto reply : allReplies) {
			// 소유자 여부
			if (currentUserId != null && reply.getUserId().equals(currentUserId)) {
				reply.setOwner(true);
			} else {
				reply.setOwner(false);
			}
			
			// 시간 표시
			reply.setTimeAgo(calculateTimeAgo(reply.getReplyCreatedAt()));
		}
		
		// 계층 구조 생성
		return buildReplyTree(allReplies);
	}
	
	/**
	 * 3. 댓글 수정
	 */
	public boolean updateReply(ReplyDto reply) {
		if (reply.getReplyContent() == null || reply.getReplyContent().trim().isEmpty()) {
			return false;
		}
		
		if (reply.getReplyContent().length() > 1000) {
			return false;
		}
		
		int result = replyDao.updateReply(reply);
		return result > 0;
	}
	
	/**
	 * 4. 댓글 삭제
	 */
	public boolean deleteReply(Long replyId, Long userId) {
		ReplyDto reply = new ReplyDto();
		reply.setReplyId(replyId);
		reply.setUserId(userId);
		
		int result = replyDao.replyDelete(reply);
		return result > 0;
	}
	
	/**
	 * 5. 댓글 수 조회
	 */
	public int getReplyCount(Long roomBoardId) {
		return replyDao.getReplyCnt(roomBoardId);
	}
	
	/**
	 * 6. 댓글 권한 체크
	 */
	public boolean checkReplyOwner(Long replyId, Long userId) {
		ReplyDto reply = replyDao.selectReplyById(replyId);
		return reply != null && 
				reply.getUserId().equals(userId) && 
				"ACTIVE".equals(reply.getStatus());
	}
	
	/**
	 * 계층 구조 생성
	 */
	private List<ReplyDto> buildReplyTree(List<ReplyDto> allReplies) {
		List<ReplyDto> rootReplies = new ArrayList<>();
		Map<Long, ReplyDto> replyMap = new HashMap<>();
		
		// 모든 댓글을 맵에 저장하고 대댓글 리스트 초기화
		for (ReplyDto reply : allReplies) {
			reply.setReplies(new ArrayList<>());
			replyMap.put(reply.getReplyId(), reply);
		}
		
		// 부모-자식 관계 설정
		for (ReplyDto reply : allReplies) {
			if (reply.getParentReplyId() != null && reply.getParentReplyId() > 0) {
				ReplyDto parent = replyMap.get(reply.getParentReplyId());
				if (parent != null) {
					parent.getReplies().add(reply);
					parent.setReplyCount(parent.getReplies().size());
				}
			} else {
				rootReplies.add(reply);
			}
		}
		
		return rootReplies;
	}
	
	/**
	 * 시간 차이 계산
	 */
	private String calculateTimeAgo(Date createdAt) {
		if (createdAt == null) {
			return "";
		}
		
		long diff = System.currentTimeMillis() - createdAt.getTime();
		long seconds = diff / 1000;
		long minutes = seconds / 60;
		long hours = minutes / 60;
		long days = hours / 24;
		long months = days / 30;
		long years = days / 365;
		
		if (seconds < 60) {
			return "방금 전";
		} else if (minutes < 60) {
			return minutes + "분 전";
		} else if (hours < 24) {
			return hours + "시간 전";
		} else if (days < 30) {
			return days + "일 전";
		} else if (months < 12) {
			return months + "개월 전";
		} else {
			return years + "년 전";
		}
	}
}