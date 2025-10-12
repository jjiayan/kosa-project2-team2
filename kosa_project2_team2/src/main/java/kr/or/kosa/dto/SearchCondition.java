package kr.or.kosa.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SearchCondition {
	private String si;              
    private String siGun;           
    private String keyword;           
    
    private Integer page = 1;       // 기본값 1
    private Integer size = 9;      // 기본값 8
    
    // offset 계산 메서드
    public int getOffset() {
        return (this.page - 1) * size;
    }
	
}
