package com.ftk.pricetemplate.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ftk.pricetemplate.service.PriceTemplateService;
import com.ftk.pricetemplate.vo.PriceTemplateVO;
import com.ftk.pricetemplate.vo.SessionTemplateVO;
import com.ftk.program.service.ProgramService;

import lombok.RequiredArgsConstructor;

/**
 * 가격 템플릿 관리 Controller
 */
@Controller
@RequiredArgsConstructor
public class PriceTemplateController {

	private final PriceTemplateService priceTemplateService;
	private final ProgramService programService;

	/**
	 * 가격 템플릿 관리 화면 (프로그램 상세 내에서 접근)
	 */
	@RequestMapping("/priceTemplateView.do")
	public String priceTemplateView(@RequestParam("programId") String programId, Model model) throws Exception {
		model.addAttribute("programList", programService.selectProgramListAllByType("SESSION"));
		model.addAttribute("selectedProgramId", programId);
		return "pricetemplate/priceTemplateView";
	}

	/**
	 * 템플릿 데이터 AJAX 조회
	 */
	@RequestMapping("/priceTemplateData.do")
	@ResponseBody
	public Map<String, Object> priceTemplateData(
			@RequestParam("programId") String programId,
			@RequestParam("dayType") String dayType) {
		return priceTemplateService.selectTemplateData(programId, dayType);
	}

	/**
	 * 가격 템플릿 단건 수정 AJAX
	 */
	@RequestMapping("/savePriceTemplate.do")
	@ResponseBody
	public Map<String, Object> savePriceTemplate(PriceTemplateVO vo) {
		Map<String, Object> result = new java.util.HashMap<>();
		try {
			priceTemplateService.updatePriceTemplate(vo);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	/**
	 * 회차 활성/비활성 토글 AJAX
	 */
	@RequestMapping("/saveSessionEnabled.do")
	@ResponseBody
	public Map<String, Object> saveSessionEnabled(SessionTemplateVO vo) {
		Map<String, Object> result = new java.util.HashMap<>();
		try {
			priceTemplateService.updateSessionTemplateEnabled(vo);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	/**
	 * 일괄 가격 조정 AJAX
	 */
	@RequestMapping("/applyBulkPriceAdjust.do")
	@ResponseBody
	public Map<String, Object> applyBulkPriceAdjust(
			@RequestParam("programId") String programId,
			@RequestParam("dayType") String dayType,
			@RequestParam("adjustAmount") int adjustAmount) {
		Map<String, Object> result = new java.util.HashMap<>();
		try {
			priceTemplateService.applyBulkPriceAdjust(programId, dayType, adjustAmount);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

}
