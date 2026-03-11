package com.ftk.holiday.service;

import java.util.List;

import com.ftk.holiday.vo.HolidayVO;
import com.ftk.common.vo.CommonDefaultVO;

public interface HolidayService {

	String insertHoliday(HolidayVO vo) throws Exception;

	void updateHoliday(HolidayVO vo) throws Exception;

	void deleteHoliday(HolidayVO vo) throws Exception;

	HolidayVO selectHoliday(HolidayVO vo) throws Exception;

	List<?> selectHolidayList(CommonDefaultVO searchVO) throws Exception;

	int selectHolidayListTotCnt(CommonDefaultVO searchVO);

	/** 특정 기간의 휴무일 날짜 목록 (yyyy-MM-dd) */
	List<String> selectHolidayDatesBetween(String startDate, String endDate) throws Exception;

}
