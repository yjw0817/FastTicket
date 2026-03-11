package com.ftk.businesshours.mapper;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import com.ftk.businesshours.vo.BusinessHoursVO;

@Mapper("businessHoursMapper")
public interface BusinessHoursMapper {

	List<BusinessHoursVO> selectBusinessHoursList();

	BusinessHoursVO selectBusinessHours(BusinessHoursVO vo);

	void updateBusinessHours(BusinessHoursVO vo);

	void insertBusinessHours(BusinessHoursVO vo);

	int selectBusinessHoursCount();

}
