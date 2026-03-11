package com.ftk.commoncode.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.commoncode.service.CommonCodeService;
import com.ftk.commoncode.vo.CommonCodeVO;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : CommonCodeController.java
 * @Description : 공통코드 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class CommonCodeController {

	private final CommonCodeService commonCodeService;

	/**
	 * 공통코드 관리 화면
	 */
	@RequestMapping(value = "/commonCodeList.do")
	public String commonCodeList() {
		return "commoncode/commonCodeList";
	}

	/**
	 * 코드 목록 조회 (AJAX) - depth + parentId 기준
	 */
	@RequestMapping(value = "/commonCodeData.do")
	@ResponseBody
	public List<CommonCodeVO> selectCommonCodeData(
			@RequestParam("depth") int depth,
			@RequestParam(value = "parentId", required = false) String parentId) {
		CommonCodeVO vo = new CommonCodeVO();
		vo.setDepth(depth);
		vo.setParentId(parentId);
		return commonCodeService.selectCommonCodeListByParent(vo);
	}

	/**
	 * 코드 상세 조회 (AJAX)
	 */
	@RequestMapping(value = "/commonCodeDetail.do")
	@ResponseBody
	public CommonCodeVO selectCommonCodeDetail(@RequestParam("codeId") String codeId) throws Exception {
		CommonCodeVO vo = new CommonCodeVO();
		vo.setCodeId(codeId);
		return commonCodeService.selectCommonCode(vo);
	}

	/**
	 * 코드 저장 (AJAX)
	 */
	@RequestMapping(value = "/saveCommonCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveCommonCode(CommonCodeVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		String codeId = commonCodeService.insertCommonCode(vo);
		result.put("success", true);
		result.put("codeId", codeId);
		result.put("message", "등록되었습니다.");
		return result;
	}

	/**
	 * 코드 수정 (AJAX)
	 */
	@RequestMapping(value = "/modifyCommonCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modifyCommonCode(CommonCodeVO vo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		commonCodeService.updateCommonCode(vo);
		result.put("success", true);
		result.put("message", "수정되었습니다.");
		return result;
	}

	/**
	 * 코드 삭제 (AJAX)
	 */
	@RequestMapping(value = "/removeCommonCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> removeCommonCode(@RequestParam("codeId") String codeId) throws Exception {
		Map<String, Object> result = new HashMap<>();
		int childCnt = commonCodeService.selectChildCount(codeId);
		if (childCnt > 0) {
			result.put("success", false);
			result.put("message", "하위 코드가 존재하여 삭제할 수 없습니다.");
			return result;
		}
		CommonCodeVO vo = new CommonCodeVO();
		vo.setCodeId(codeId);
		commonCodeService.deleteCommonCode(vo);
		result.put("success", true);
		result.put("message", "삭제되었습니다.");
		return result;
	}

}
