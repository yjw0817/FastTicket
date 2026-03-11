package com.ftk.discount.service;

import java.util.List;
import com.ftk.discount.vo.DiscountVO;
import com.ftk.common.vo.CommonDefaultVO;

public interface DiscountService {

	String insertDiscount(DiscountVO vo) throws Exception;

	void updateDiscount(DiscountVO vo) throws Exception;

	void deleteDiscount(DiscountVO vo) throws Exception;

	DiscountVO selectDiscount(DiscountVO vo) throws Exception;

	List<?> selectDiscountList(CommonDefaultVO searchVO) throws Exception;

	int selectDiscountListTotCnt(CommonDefaultVO searchVO);

	List<String> selectDiscountProgramIds(String discountId);

	List<?> selectDiscountProgramsWithValues(String discountId);

	/** 프로그램에 적용 가능한 할인 목록 */
	List<?> selectApplicableDiscounts(String programId, String eventDate);

}
