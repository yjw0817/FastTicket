package com.ftk.booking.controller;

import java.util.List;

import com.ftk.booking.service.BookingService;
import com.ftk.booking.vo.BookingVO;
import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.price.service.TicketPriceService;
import com.ftk.price.vo.TicketPriceVO;
import com.ftk.schedule.service.ScheduleService;
import com.ftk.schedule.vo.ScheduleVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : BookingController.java
 * @Description : 예매 Controller 클래스
 */
@Controller
@RequiredArgsConstructor
public class BookingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BookingController.class);

	/** BookingService */
	private final BookingService bookingService;

	/** ScheduleService */
	private final ScheduleService scheduleService;

	/** TicketPriceService */
	private final TicketPriceService ticketPriceService;

	/** EgovPropertyService */
	private final EgovPropertyService propertiesService;

	/**
	 * 예매 등록/수정 폼에 필요한 공연일정 목록과 티켓가격 목록을 Model에 담는다.
	 * @param model - 뷰에 전달할 모델
	 * @param scheduleId - 선택된 공연일정ID (null이면 일정목록만 로드)
	 */
	private void loadFormData(Model model, String scheduleId) throws Exception {
		CommonDefaultVO scheduleSearchVO = new CommonDefaultVO();
		scheduleSearchVO.setRecordCountPerPage(9999);
		scheduleSearchVO.setFirstIndex(0);
		List<?> scheduleList = scheduleService.selectScheduleList(scheduleSearchVO);
		model.addAttribute("scheduleList", scheduleList);

		if (scheduleId != null && !scheduleId.isEmpty()) {
			try {
				ScheduleVO scheduleVO = new ScheduleVO();
				scheduleVO.setScheduleId(scheduleId);
				ScheduleVO selectedSchedule = scheduleService.selectSchedule(scheduleVO);
				if (selectedSchedule != null && selectedSchedule.getProgramId() != null) {
					TicketPriceVO priceSearchVO = new TicketPriceVO();
					priceSearchVO.setProgramId(selectedSchedule.getProgramId());
					List<?> priceList = ticketPriceService.selectTicketPriceListByProgram(priceSearchVO);
					model.addAttribute("priceList", priceList);
					model.addAttribute("selectedSchedule", selectedSchedule);
				}
			} catch (Exception e) {
				LOGGER.warn("공연일정 또는 티켓가격 조회 중 오류: scheduleId={}", scheduleId, e);
			}
		}
	}

	/**
	 * 예매 목록을 조회한다. (페이징)
	 * @param searchVO - 조회할 정보가 담긴 CommonDefaultVO
	 * @param model
	 * @return "booking/bookingList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/bookingList.do")
	public String selectBookingList(@ModelAttribute("searchVO") CommonDefaultVO searchVO, ModelMap model)
			throws Exception {

		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> bookingList = bookingService.selectBookingList(searchVO);
		model.addAttribute("resultList", bookingList);

		int totCnt = bookingService.selectBookingListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "booking/bookingList";
	}

	/**
	 * 예매 등록 화면을 조회한다.
	 * - 공연일정 목록 로드 (콤보박스용)
	 * - scheduleId 파라미터가 있으면 해당 일정의 프로그램 티켓가격 목록도 로드
	 * @param scheduleId - 선택된 공연일정ID (옵션)
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "booking/bookingRegister"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addBooking.do", method = RequestMethod.GET)
	public String addBookingView(
			@RequestParam(value = "scheduleId", required = false, defaultValue = "") String scheduleId,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO,
			Model model) throws Exception {

		loadFormData(model, scheduleId);

		BookingVO bookingVO = new BookingVO();
		if (scheduleId != null && !scheduleId.isEmpty()) {
			bookingVO.setScheduleId(scheduleId);
		}
		model.addAttribute("bookingVO", bookingVO);
		return "booking/bookingRegister";
	}

	/**
	 * 예매를 등록한다.
	 * @param bookingVO - 등록할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param bindingResult
	 * @param model
	 * @param status
	 * @return "forward:/bookingList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/addBooking.do", method = RequestMethod.POST)
	public String addBooking(@ModelAttribute("searchVO") CommonDefaultVO searchVO,
			BookingVO bookingVO,
			BindingResult bindingResult,
			Model model,
			SessionStatus status) throws Exception {

		// 필수 항목 파라미터 검증
		boolean hasError = false;
		if (bookingVO.getBookerNm() == null || bookingVO.getBookerNm().trim().isEmpty()) {
			bindingResult.rejectValue("bookerNm", "required", "예매자명은 필수입니다.");
			hasError = true;
		}
		if (bookingVO.getBookerTel() == null || bookingVO.getBookerTel().trim().isEmpty()) {
			bindingResult.rejectValue("bookerTel", "required", "연락처는 필수입니다.");
			hasError = true;
		}
		if (bookingVO.getScheduleId() == null || bookingVO.getScheduleId().trim().isEmpty()) {
			bindingResult.rejectValue("scheduleId", "required", "공연일정을 선택해 주세요.");
			hasError = true;
		}

		if (hasError) {
			loadFormData(model, bookingVO.getScheduleId());
			model.addAttribute("bookingVO", bookingVO);
			return "booking/bookingRegister";
		}

		try {
			bookingService.insertBooking(bookingVO);
		} catch (IllegalArgumentException e) {
			model.addAttribute("errorMessage", e.getMessage());
			loadFormData(model, bookingVO.getScheduleId());
			model.addAttribute("bookingVO", bookingVO);
			return "booking/bookingRegister";
		}

		status.setComplete();
		return "forward:/bookingList.do";
	}

	/**
	 * 예매 수정/상세 화면을 조회한다.
	 * - 예매 정보 및 예매상세 목록 포함하여 조회
	 * @param bookingId - 조회할 예매ID
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "booking/bookingRegister"
	 * @exception Exception
	 */
	@RequestMapping("/updateBookingView.do")
	public String updateBookingView(@RequestParam("selectedId") String bookingId,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO,
			Model model) throws Exception {
		BookingVO bookingVO = new BookingVO();
		bookingVO.setBookingId(bookingId);
		BookingVO result = bookingService.selectBooking(bookingVO);
		model.addAttribute("bookingVO", result);
		return "booking/bookingRegister";
	}

	/**
	 * 예매 상태를 수정한다. (예매상태, 결제상태 변경)
	 * @param bookingVO - 수정할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/bookingList.do"
	 * @exception Exception
	 */
	@RequestMapping("/updateBooking.do")
	public String updateBooking(@ModelAttribute("searchVO") CommonDefaultVO searchVO,
			BookingVO bookingVO,
			BindingResult bindingResult,
			Model model,
			SessionStatus status) throws Exception {
		bookingService.updateBooking(bookingVO);
		status.setComplete();
		return "forward:/bookingList.do";
	}

	/**
	 * 예매를 삭제한다. (예매상세 포함)
	 * @param bookingVO - 삭제할 정보가 담긴 VO
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param status
	 * @return "forward:/bookingList.do"
	 * @exception Exception
	 */
	@RequestMapping("/deleteBooking.do")
	public String deleteBooking(BookingVO bookingVO,
			@ModelAttribute("searchVO") CommonDefaultVO searchVO,
			SessionStatus status) throws Exception {
		bookingService.deleteBooking(bookingVO);
		status.setComplete();
		return "forward:/bookingList.do";
	}

}
