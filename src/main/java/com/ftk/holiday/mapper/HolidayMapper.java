package com.ftk.holiday.mapper;

import java.util.List;

import com.ftk.holiday.vo.HolidayVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("holidayMapper")
public interface HolidayMapper {

	void insertHoliday(HolidayVO vo) throws Exception;

	void updateHoliday(HolidayVO vo) throws Exception;

	void deleteHoliday(HolidayVO vo) throws Exception;

	HolidayVO selectHoliday(HolidayVO vo) throws Exception;

	List<?> selectHolidayList(CommonDefaultVO searchVO) throws Exception;

	int selectHolidayListTotCnt(CommonDefaultVO searchVO);

	/** 특정 기간의 휴무일 날짜 목록 조회 (벌크 생성용) */
	List<String> selectHolidayDatesBetween(HolidayVO vo) throws Exception;

}
