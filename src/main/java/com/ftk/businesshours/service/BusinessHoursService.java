package com.ftk.businesshours.service;

import java.util.List;
import com.ftk.businesshours.vo.BusinessHoursVO;

public interface BusinessHoursService {

	List<BusinessHoursVO> selectBusinessHoursList() throws Exception;

	void saveBusinessHoursList(List<BusinessHoursVO> list) throws Exception;

}
