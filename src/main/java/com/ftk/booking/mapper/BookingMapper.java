package com.ftk.booking.mapper;

import java.util.List;

import com.ftk.booking.vo.BookingVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : BookingMapper.java
 * @Description : 예매 MyBatis Mapper 인터페이스
 */
@Mapper("bookingMapper")
public interface BookingMapper {

	/**
	 * 예매를 등록한다.
	 * @param vo - 등록할 정보가 담긴 BookingVO
	 * @exception Exception
	 */
	void insertBooking(BookingVO vo) throws Exception;

	/**
	 * 예매를 수정한다. (상태 변경)
	 * @param vo - 수정할 정보가 담긴 BookingVO
	 * @exception Exception
	 */
	void updateBooking(BookingVO vo) throws Exception;

	/**
	 * 예매를 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 BookingVO
	 * @exception Exception
	 */
	void deleteBooking(BookingVO vo) throws Exception;

	/**
	 * 예매를 조회한다.
	 * @param vo - 조회할 정보가 담긴 BookingVO
	 * @return 조회한 예매
	 * @exception Exception
	 */
	BookingVO selectBooking(BookingVO vo) throws Exception;

	/**
	 * 예매 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 예매 목록
	 * @exception Exception
	 */
	List<?> selectBookingList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 예매 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 예매 총 갯수
	 */
	int selectBookingListTotCnt(CommonDefaultVO searchVO);

}
