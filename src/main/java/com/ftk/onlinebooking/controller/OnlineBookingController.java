package com.ftk.onlinebooking.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ftk.booking.service.BookingService;
import com.ftk.booking.vo.BookingDetailVO;
import com.ftk.booking.vo.BookingVO;
import com.ftk.program.service.ProgramService;
import com.ftk.program.vo.ProgramDiscountVO;
import com.ftk.schedule.service.ScheduleService;
import com.ftk.schedule.vo.ScheduleVO;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class OnlineBookingController {

	private final ProgramService programService;
	private final ScheduleService scheduleService;
	private final BookingService bookingService;

	/**
	 * 온라인 예약 메인 페이지
	 */
	@RequestMapping(value = "/onlineBooking.do")
	public String onlineBookingPage(ModelMap model) throws Exception {
		List<?> programList = programService.selectProgramListAllByType("SESSION");
		model.addAttribute("programList", programList);
		return "onlinebooking/onlineBooking";
	}

	/**
	 * 프로그램의 예약 가능 날짜 목록 (AJAX)
	 */
	@RequestMapping(value = "/onlineBookingDates.do")
	@ResponseBody
	public List<String> getAvailableDates(@RequestParam("programId") String programId) {
		return scheduleService.selectAvailableDates(programId);
	}

	/**
	 * 특정 날짜의 예약 가능 회차 목록 (AJAX)
	 */
	@RequestMapping(value = "/onlineBookingSessions.do")
	@ResponseBody
	public List<ScheduleVO> getAvailableSessions(
			@RequestParam("programId") String programId,
			@RequestParam("eventDate") String eventDate) {
		return scheduleService.selectAvailableSessions(programId, eventDate);
	}

	/**
	 * 회차의 가격 목록 + 프로그램 할인 정보 (AJAX)
	 * PRICE_TEMPLATE + DATE_PRICE_OVERRIDE 기반 가격 조회
	 * PROGRAM_DISCOUNT 기반 할인 조회
	 */
	@RequestMapping(value = "/onlineBookingPrices.do")
	@ResponseBody
	public Map<String, Object> getSessionPrices(
			@RequestParam("scheduleId") String scheduleId,
			@RequestParam(value = "programId", required = false) String programId,
			@RequestParam(value = "eventDate", required = false) String eventDate,
			@RequestParam(value = "sessionNo", defaultValue = "1") int sessionNo,
			@RequestParam(value = "dayType", defaultValue = "WEEKDAY") String dayType) throws Exception {

		Map<String, Object> result = new HashMap<>();

		// 가격: PRICE_TEMPLATE + DATE_PRICE_OVERRIDE 기반
		if (programId != null && eventDate != null) {
			List<?> prices = scheduleService.selectDatePrices(programId, eventDate, sessionNo, dayType);
			result.put("prices", prices);

			// 할인: PROGRAM_DISCOUNT 기반
			List<ProgramDiscountVO> discounts = programService.selectProgramDiscounts(programId);
			result.put("discounts", discounts);
		}

		return result;
	}

	/**
	 * 온라인 예약 제출 (AJAX)
	 */
	@RequestMapping(value = "/submitOnlineBooking.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> submitBooking(
			@RequestParam("scheduleId") String scheduleId,
			@RequestParam("bookerNm") String bookerNm,
			@RequestParam("bookerTel") String bookerTel,
			@RequestParam(value = "bookerEmail", required = false) String bookerEmail,
			@RequestParam("typeIds") String typeIds,
			@RequestParam("prices") String prices,
			@RequestParam("qtys") String qtys) throws Exception {

		Map<String, Object> result = new HashMap<>();

		String[] idArr = typeIds.split(",");
		String[] priceArr = prices.split(",");
		String[] qtyArr = qtys.split(",");

		int totalQty = 0;
		int totalAmt = 0;
		List<BookingDetailVO> details = new ArrayList<>();

		for (int i = 0; i < idArr.length; i++) {
			int qty = Integer.parseInt(qtyArr[i].trim());
			if (qty <= 0) continue;

			int price = Integer.parseInt(priceArr[i].trim());
			for (int j = 0; j < qty; j++) {
				BookingDetailVO d = new BookingDetailVO();
				d.setPriceId(idArr[i].trim()); // typeId를 priceId로 저장 (호환)
				d.setTicketAmt(price);
				d.setQty(1);
				details.add(d);
			}
			totalQty += qty;
			totalAmt += qty * price;
		}

		if (totalQty <= 0) {
			result.put("success", false);
			result.put("message", "수량을 1개 이상 선택하세요.");
			return result;
		}

		int updated = scheduleService.decreaseOnlineAvail(scheduleId, totalQty);
		if (updated == 0) {
			result.put("success", false);
			result.put("message", "온라인 잔여석이 부족합니다. 다른 회차를 선택하세요.");
			return result;
		}

		BookingVO booking = new BookingVO();
		booking.setScheduleId(scheduleId);
		booking.setBookerNm(bookerNm);
		booking.setBookerTel(bookerTel);
		booking.setBookerEmail(bookerEmail);
		booking.setBookingStatus("RESERVED");
		booking.setPaymentStatus("PENDING");
		booking.setBookingChannel("ONLINE");
		booking.setTotalQty(totalQty);
		booking.setTotalAmt(totalAmt);
		booking.setBookingDetails(details);

		String bookingId = bookingService.insertBooking(booking);

		result.put("success", true);
		result.put("bookingId", bookingId);
		result.put("totalQty", totalQty);
		result.put("totalAmt", totalAmt);
		result.put("message", "예약이 완료되었습니다.");
		return result;
	}

}
