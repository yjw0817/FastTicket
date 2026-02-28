package egovframework.example.program.web;

import java.util.List;

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

import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.example.program.service.ProgramService;
import egovframework.example.program.service.ProgramVO;
import egovframework.example.venue.service.VenueService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springmodules.validation.commons.DefaultBeanValidator;

/**
 * @Class Name : ProgramController.java
 * @Description : 프로그램 Controller Class
 */
@Controller
public class ProgramController {

	/** ProgramService */
	@Resource(name = "programService")
	private ProgramService programService;

	/** VenueService (콤보박스용) */
	@Resource(name = "venueService")
	private VenueService venueService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	/**
	 * 프로그램 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "program/programList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/programList.do")
	public String selectProgramList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> programList = programService.selectProgramList(searchVO);
		model.addAttribute("resultList", programList);

		int totCnt = programService.selectProgramListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "program/programList";
	}

	/**
	 * 프로그램 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "program/programRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addProgram.do", method = RequestMethod.GET)
	public String addProgramView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("programVO", new ProgramVO());

		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setRecordCountPerPage(9999);
		venueSearchVO.setFirstIndex(0);
		List<?> venueList = venueService.selectVenueList(venueSearchVO);
		model.addAttribute("venueList", venueList);

		return "program/programRegister";
	}

	/**
	 * 프로그램을 등록한다.
	 * @param programVO - 등록할 정보가 담긴 ProgramVO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/programList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addProgram.do", method = RequestMethod.POST)
	public String addProgram(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ProgramVO programVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		if (bindingResult.hasErrors()) {
			CommonDefaultVO venueSearchVO = new CommonDefaultVO();
			venueSearchVO.setRecordCountPerPage(9999);
			venueSearchVO.setFirstIndex(0);
			model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));
			model.addAttribute("programVO", programVO);
			return "program/programRegister";
		}

		programService.insertProgram(programVO);
		status.setComplete();
		return "forward:/programList.do";
	}

	/**
	 * 프로그램 수정화면을 조회한다.
	 * @param id - 수정할 프로그램 id
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "program/programRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateProgramView.do")
	public String updateProgramView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {

		ProgramVO programVO = new ProgramVO();
		programVO.setProgramId(id);
		ProgramVO result = programService.selectProgram(programVO);
		model.addAttribute("programVO", result);

		CommonDefaultVO venueSearchVO = new CommonDefaultVO();
		venueSearchVO.setRecordCountPerPage(9999);
		venueSearchVO.setFirstIndex(0);
		List<?> venueList = venueService.selectVenueList(venueSearchVO);
		model.addAttribute("venueList", venueList);

		return "program/programRegister";
	}

	/**
	 * 프로그램을 수정한다.
	 * @param programVO - 수정할 정보가 담긴 ProgramVO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/programList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateProgram.do")
	public String updateProgram(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ProgramVO programVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		if (bindingResult.hasErrors()) {
			CommonDefaultVO venueSearchVO = new CommonDefaultVO();
			venueSearchVO.setRecordCountPerPage(9999);
			venueSearchVO.setFirstIndex(0);
			model.addAttribute("venueList", venueService.selectVenueList(venueSearchVO));
			model.addAttribute("programVO", programVO);
			return "program/programRegister";
		}

		programService.updateProgram(programVO);
		status.setComplete();
		return "forward:/programList.do";
	}

	/**
	 * 프로그램을 삭제한다.
	 * @param programVO - 삭제할 정보가 담긴 ProgramVO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/programList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteProgram.do")
	public String deleteProgram(ProgramVO programVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		programService.deleteProgram(programVO);
		status.setComplete();
		return "forward:/programList.do";
	}

}
