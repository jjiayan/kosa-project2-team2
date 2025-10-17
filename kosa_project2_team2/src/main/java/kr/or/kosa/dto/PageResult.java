package kr.or.kosa.dto;

import java.util.List;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PageResult<T> {
	private List<T> data;
    private int totalCount;
    private int totalPages;
    private int currentPage;
    private int pageSize;
    private List<RegionDto> mainRegionList;
    private String keyword;
    private String si;
    private String siGun;
}



