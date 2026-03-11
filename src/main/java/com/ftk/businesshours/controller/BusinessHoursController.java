package com.ftk.businesshours.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.businesshours.service.BusinessHoursService;
import com.ftk.businesshours.vo.BusinessHoursVO;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class BusinessHoursController {

	private final BusinessHoursService businessHoursService;

	/**
	 * 영업시간 설정 페이지
	 */
	@RequestMapping(value = "/businessHoursList.do")
	public String selectBusinessHoursList(ModelMap model) throws Exception {
		List<BusinessHoursVO> list = businessHoursService.selectBusinessHoursList();
		model.addAttribute("hoursList", list);
		return "businesshours/businessHoursList";
	}

	/**
	 * 영업시간 일괄 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveBusinessHours.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBusinessHours(
			@RequestParam("bhId") String[] bhIds,
			@RequestParam("dayOfWeek") int[] dayOfWeeks,
			@RequestParam("openTime") String[] openTimes,
			@RequestParam("closeTime") String[] closeTimes,
			@RequestParam("useYn") String[] useYns) throws Exception {

		Map<String, Object> result = new HashMap<>();

		List<BusinessHoursVO> list = new ArrayList<>();
		for (int i = 0; i < bhIds.length; i++) {
			BusinessHoursVO vo = new BusinessHoursVO();
			vo.setBhId(bhIds[i]);
			vo.setDayOfWeek(dayOfWeeks[i]);
			vo.setOpenTime(openTimes[i]);
			vo.setCloseTime(closeTimes[i]);
			vo.setUseYn(useYns[i]);
			list.add(vo);
		}

		businessHoursService.saveBusinessHoursList(list);
		result.put("success", true);
		result.put("message", "저장되었습니다.");
		return result;
	}

	/**
	 * 영업시간 조회 API (벌크 생성에서 활용)
	 */
	@RequestMapping(value = "/businessHoursApi.do")
	@ResponseBody
	public List<BusinessHoursVO> getBusinessHoursApi() throws Exception {
		return businessHoursService.selectBusinessHoursList();
	}

}
