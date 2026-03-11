package com.ftk.businesshours.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ftk.businesshours.mapper.BusinessHoursMapper;
import com.ftk.businesshours.vo.BusinessHoursVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import lombok.RequiredArgsConstructor;

@Service("businessHoursService")
@RequiredArgsConstructor
public class BusinessHoursServiceImpl extends EgovAbstractServiceImpl implements BusinessHoursService {

	private final BusinessHoursMapper businessHoursMapper;
	private final EgovIdGnrService businessHoursIdGnrService;

	@Override
	public List<BusinessHoursVO> selectBusinessHoursList() throws Exception {
		// 초기 데이터가 없으면 7일치 기본값 생성
		if (businessHoursMapper.selectBusinessHoursCount() == 0) {
			initDefaultData();
		}
		return businessHoursMapper.selectBusinessHoursList();
	}

	@Override
	public void saveBusinessHoursList(List<BusinessHoursVO> list) throws Exception {
		for (BusinessHoursVO vo : list) {
			if (vo.getBhId() != null && !vo.getBhId().isEmpty()) {
				businessHoursMapper.updateBusinessHours(vo);
			} else {
				vo.setBhId(businessHoursIdGnrService.getNextStringId());
				businessHoursMapper.insertBusinessHours(vo);
			}
		}
	}

	/** 월~일 7일 기본 데이터 생성 (09:00~18:00) */
	private void initDefaultData() throws Exception {
		for (int day = 1; day <= 7; day++) {
			BusinessHoursVO vo = new BusinessHoursVO();
			vo.setBhId(businessHoursIdGnrService.getNextStringId());
			vo.setDayOfWeek(day);
			vo.setOpenTime("09:00");
			vo.setCloseTime("18:00");
			vo.setUseYn("Y");
			businessHoursMapper.insertBusinessHours(vo);
		}
	}

}
