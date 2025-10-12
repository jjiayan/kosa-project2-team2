package kr.or.kosa.dto;

import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class RegionDto {
	private Integer mainRegionId;
	private Integer subRegionId;
	private String mainRegion;
	private String subRegion;

}
