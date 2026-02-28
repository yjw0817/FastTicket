package egovframework.example.booking.web;

import java.util.List;

import egovframework.example.booking.service.BookingDetailVO;
import egovframework.example.booking.service.BookingService;
import egovframework.example.booking.service.BookingVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.example.price.service.TicketPriceService;
import egovframework.example.price.service.TicketPriceVO;
import egovframework.example.schedule.service.ScheduleService;
import egovframework.example.schedule.service.ScheduleVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import javax.annotation.Resource;

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
import org.springmodules.validation.commons.DefaultBeanValidator;

/**
 * @Class Name : BookingController.java
 * @Description : 예매 Controller 클래스
 */
@Controller
public class BookingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BookingController.class);

	/** BookingService */
	@Resource(name = "bookingService")
	private BookingService bookingService;

	/** ScheduleService */
	@Resource(name = "scheduleService")
	private ScheduleService scheduleService;

	/** TicketPriceService */
	@Resource(name = "ticketPriceService")
	private TicketPriceService ticketPriceService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

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

		// 공연일정 목록 로드 (전체, 페이징 없이)
		CommonDefaultVO scheduleSearchVO = new CommonDefaultVO();
		scheduleSearchVO.setRecordCountPerPage(9999);
		scheduleSearchVO.setFirstIndex(0);
		List<?> scheduleList = scheduleService.selectScheduleList(scheduleSearchVO);
		model.addAttribute("scheduleList", scheduleList);

		BookingVO bookingVO = new BookingVO();

		// 선택된 일정이 있으면 해당 프로그램의 티켓가격 목록 로드
		if (scheduleId != null && !scheduleId.isEmpty()) {
			bookingVO.setScheduleId(scheduleId);
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

		// 필수 항목 수동 검증 (commons-validator 미사용 시)
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
			// 오류 발생 시 화면 재표시를 위해 필요 데이터 재로드
			CommonDefaultVO scheduleSearchVO = new CommonDefaultVO();
			scheduleSearchVO.setRecordCountPerPage(9999);
			scheduleSearchVO.setFirstIndex(0);
			List<?> scheduleList = scheduleService.selectScheduleList(scheduleSearchVO);
			model.addAttribute("scheduleList", scheduleList);

			if (bookingVO.getScheduleId() != null && !bookingVO.getScheduleId().isEmpty()) {
				try {
					ScheduleVO scheduleVO = new ScheduleVO();
					scheduleVO.setScheduleId(bookingVO.getScheduleId());
					ScheduleVO selectedSchedule = scheduleService.selectSchedule(scheduleVO);
					if (selectedSchedule != null && selectedSchedule.getProgramId() != null) {
						TicketPriceVO priceSearchVO = new TicketPriceVO();
						priceSearchVO.setProgramId(selectedSchedule.getProgramId());
						List<?> priceList = ticketPriceService.selectTicketPriceListByProgram(priceSearchVO);
						model.addAttribute("priceList", priceList);
						model.addAttribute("selectedSchedule", selectedSchedule);
					}
				} catch (Exception e) {
					LOGGER.warn("재로드 중 오류: scheduleId={}", bookingVO.getScheduleId(), e);
				}
			}
			model.addAttribute("bookingVO", bookingVO);
			return "booking/bookingRegister";
		}

		// 예매상세가 없거나 수량이 모두 0인 경우 검증
		List<BookingDetailVO> details = bookingVO.getBookingDetails();
		int totalQty = 0;
		if (details != null) {
			for (BookingDetailVO detail : details) {
				totalQty += detail.getQty();
			}
		}
		if (totalQty <= 0) {
			model.addAttribute("errorMessage", "1매 이상 선택해 주세요.");
			CommonDefaultVO scheduleSearchVO = new CommonDefaultVO();
			scheduleSearchVO.setRecordCountPerPage(9999);
			scheduleSearchVO.setFirstIndex(0);
			List<?> scheduleList = scheduleService.selectScheduleList(scheduleSearchVO);
			model.addAttribute("scheduleList", scheduleList);

			try {
				ScheduleVO scheduleVO = new ScheduleVO();
				scheduleVO.setScheduleId(bookingVO.getScheduleId());
				ScheduleVO selectedSchedule = scheduleService.selectSchedule(scheduleVO);
				if (selectedSchedule != null && selectedSchedule.getProgramId() != null) {
					TicketPriceVO priceSearchVO = new TicketPriceVO();
					priceSearchVO.setProgramId(selectedSchedule.getProgramId());
					List<?> priceList = ticketPriceService.selectTicketPriceListByProgram(priceSearchVO);
					model.addAttribute("priceList", priceList);
					model.addAttribute("selectedSchedule", selectedSchedule);
				}
			} catch (Exception e) {
				LOGGER.warn("재로드 중 오류: scheduleId={}", bookingVO.getScheduleId(), e);
			}
			model.addAttribute("bookingVO", bookingVO);
			return "booking/bookingRegister";
		}

		bookingService.insertBooking(bookingVO);
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
