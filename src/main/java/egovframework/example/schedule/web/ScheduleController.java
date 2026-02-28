package egovframework.example.schedule.web;

import java.util.List;

import egovframework.example.schedule.service.ScheduleService;
import egovframework.example.schedule.service.ScheduleVO;
import egovframework.example.program.service.ProgramService;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springmodules.validation.commons.DefaultBeanValidator;

/**
 * @Class Name : ScheduleController.java
 * @Description : 공연일정 Controller 클래스
 */
@Controller
public class ScheduleController {

	/** ScheduleService */
	@Resource(name = "scheduleService")
	private ScheduleService scheduleService;

	/** ProgramService */
	@Resource(name = "programService")
	private ProgramService programService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	/**
	 * 공연일정 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "schedule/scheduleList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/scheduleList.do")
	public String selectScheduleList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> scheduleList = scheduleService.selectScheduleList(searchVO);
		model.addAttribute("resultList", scheduleList);

		int totCnt = scheduleService.selectScheduleListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "schedule/scheduleList";
	}

	/**
	 * 공연일정 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "schedule/scheduleRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSchedule.do", method = RequestMethod.GET)
	public String addScheduleView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("scheduleVO", new ScheduleVO());
		model.addAttribute("programList", programService.selectProgramListAll());
		return "schedule/scheduleRegister";
	}

	/**
	 * 공연일정을 등록한다.
	 * @param scheduleVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/scheduleList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addSchedule.do", method = RequestMethod.POST)
	public String addSchedule(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ScheduleVO scheduleVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(scheduleVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("scheduleVO", scheduleVO);
			model.addAttribute("programList", programService.selectProgramListAll());
			return "schedule/scheduleRegister";
		}

		scheduleService.insertSchedule(scheduleVO);
		status.setComplete();
		return "forward:/scheduleList.do";
	}

	/**
	 * 공연일정 수정화면을 조회한다.
	 * @param id - 수정할 일정 ID
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "schedule/scheduleRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateScheduleView.do")
	public String updateScheduleView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		ScheduleVO scheduleVO = new ScheduleVO();
		scheduleVO.setScheduleId(id);
		model.addAttribute(selectSchedule(scheduleVO, searchVO));
		model.addAttribute("programList", programService.selectProgramListAll());
		return "schedule/scheduleRegister";
	}

	/**
	 * 공연일정을 조회한다.
	 * @param scheduleVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @return 조회한 공연일정
	 * @exception Exception
	 */
	public ScheduleVO selectSchedule(ScheduleVO scheduleVO,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO) throws Exception {
		return scheduleService.selectSchedule(scheduleVO);
	}

	/**
	 * 공연일정을 수정한다.
	 * @param scheduleVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/scheduleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateSchedule.do")
	public String updateSchedule(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ScheduleVO scheduleVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(scheduleVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("scheduleVO", scheduleVO);
			model.addAttribute("programList", programService.selectProgramListAll());
			return "schedule/scheduleRegister";
		}

		scheduleService.updateSchedule(scheduleVO);
		status.setComplete();
		return "forward:/scheduleList.do";
	}

	/**
	 * 공연일정을 삭제한다.
	 * @param scheduleVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/scheduleList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteSchedule.do")
	public String deleteSchedule(ScheduleVO scheduleVO,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, SessionStatus status) throws Exception {
		scheduleService.deleteSchedule(scheduleVO);
		status.setComplete();
		return "forward:/scheduleList.do";
	}

}
