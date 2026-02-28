package egovframework.example.member.web;

import java.util.List;

import egovframework.example.member.service.MemberService;
import egovframework.example.member.service.MemberVO;
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
 * @Class Name : MemberController.java
 * @Description : 회원 Controller 클래스
 */
@Controller
public class MemberController {

	/** MemberService */
	@Resource(name = "memberService")
	private MemberService memberService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	/**
	 * 회원 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "member/memberList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/memberList.do")
	public String selectMemberList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model) throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> memberList = memberService.selectMemberList(searchVO);
		model.addAttribute("resultList", memberList);

		int totCnt = memberService.selectMemberListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "member/memberList";
	}

	/**
	 * 회원 등록 화면을 조회한다.
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "member/memberRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addMember.do", method = RequestMethod.GET)
	public String addMemberView(@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("memberVO", new MemberVO());
		return "member/memberRegister";
	}

	/**
	 * 회원을 등록한다.
	 * @param memberVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/memberList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addMember.do", method = RequestMethod.POST)
	public String addMember(@ModelAttribute("searchVO") CommonDefaultVO searchVO, MemberVO memberVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(memberVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("memberVO", memberVO);
			return "member/memberRegister";
		}

		memberService.insertMember(memberVO);
		status.setComplete();
		return "forward:/memberList.do";
	}

	/**
	 * 회원 수정화면을 조회한다.
	 * @param id - 수정할 회원 ID
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "member/memberRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateMemberView.do")
	public String updateMemberView(@RequestParam("selectedId") String id,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO, Model model) throws Exception {
		MemberVO memberVO = new MemberVO();
		memberVO.setMemberId(id);
		model.addAttribute(selectMember(memberVO, searchVO));
		return "member/memberRegister";
	}

	/**
	 * 회원을 조회한다.
	 * @param memberVO - 조회할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @return 조회한 회원
	 * @exception Exception
	 */
	public MemberVO selectMember(MemberVO memberVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO) throws Exception {
		return memberService.selectMember(memberVO);
	}

	/**
	 * 회원을 수정한다.
	 * @param memberVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/memberList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateMember.do")
	public String updateMember(@ModelAttribute("searchVO") CommonDefaultVO searchVO, MemberVO memberVO,
			BindingResult bindingResult, Model model, SessionStatus status) throws Exception {

		beanValidator.validate(memberVO, bindingResult);

		if (bindingResult.hasErrors()) {
			model.addAttribute("memberVO", memberVO);
			return "member/memberRegister";
		}

		memberService.updateMember(memberVO);
		status.setComplete();
		return "forward:/memberList.do";
	}

	/**
	 * 회원을 삭제한다.
	 * @param memberVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/memberList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteMember.do")
	public String deleteMember(MemberVO memberVO, @ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		memberService.deleteMember(memberVO);
		status.setComplete();
		return "forward:/memberList.do";
	}

}
