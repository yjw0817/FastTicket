package com.ftk.holiday.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ftk.holiday.mapper.HolidayMapper;
import com.ftk.holiday.vo.HolidayVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import lombok.RequiredArgsConstructor;

@Service("holidayService")
@RequiredArgsConstructor
public class HolidayServiceImpl extends EgovAbstractServiceImpl implements HolidayService {

	private final HolidayMapper holidayMapper;
	private final EgovIdGnrService holidayIdGnrService;

	@Override
	public String insertHoliday(HolidayVO vo) throws Exception {
		String id = holidayIdGnrService.getNextStringId();
		vo.setHolidayId(id);
		holidayMapper.insertHoliday(vo);
		return id;
	}

	@Override
	public void updateHoliday(HolidayVO vo) throws Exception {
		holidayMapper.updateHoliday(vo);
	}

	@Override
	public void deleteHoliday(HolidayVO vo) throws Exception {
		holidayMapper.deleteHoliday(vo);
	}

	@Override
	public HolidayVO selectHoliday(HolidayVO vo) throws Exception {
		return holidayMapper.selectHoliday(vo);
	}

	@Override
	public List<?> selectHolidayList(CommonDefaultVO searchVO) throws Exception {
		return holidayMapper.selectHolidayList(searchVO);
	}

	@Override
	public int selectHolidayListTotCnt(CommonDefaultVO searchVO) {
		return holidayMapper.selectHolidayListTotCnt(searchVO);
	}

	@Override
	public List<String> selectHolidayDatesBetween(String startDate, String endDate) throws Exception {
		HolidayVO vo = new HolidayVO();
		vo.setSearchCondition(startDate);
		vo.setSearchKeyword(endDate);
		return holidayMapper.selectHolidayDatesBetween(vo);
	}

}
