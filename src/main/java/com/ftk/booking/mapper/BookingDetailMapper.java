package com.ftk.booking.mapper;

import java.util.List;

import com.ftk.booking.vo.BookingDetailVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : BookingDetailMapper.java
 * @Description : 예매상세 MyBatis Mapper 인터페이스
 */
@Mapper("bookingDetailMapper")
public interface BookingDetailMapper {

	/**
	 * 예매상세를 등록한다.
	 * @param vo - 등록할 정보가 담긴 BookingDetailVO
	 * @exception Exception
	 */
	void insertBookingDetail(BookingDetailVO vo) throws Exception;

	/**
	 * 예매ID에 해당하는 모든 예매상세를 삭제한다.
	 * @param vo - bookingId가 담긴 BookingDetailVO
	 * @exception Exception
	 */
	void deleteBookingDetailByBooking(BookingDetailVO vo) throws Exception;

	/**
	 * 예매ID에 해당하는 예매상세 목록을 조회한다.
	 * @param vo - bookingId가 담긴 BookingDetailVO
	 * @return 예매상세 목록
	 * @exception Exception
	 */
	List<?> selectBookingDetailList(BookingDetailVO vo) throws Exception;

}
