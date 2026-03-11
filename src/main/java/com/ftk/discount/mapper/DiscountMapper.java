package com.ftk.discount.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import com.ftk.discount.vo.DiscountVO;
import com.ftk.common.vo.CommonDefaultVO;

@Mapper("discountMapper")
public interface DiscountMapper {

	void insertDiscount(DiscountVO vo);

	void updateDiscount(DiscountVO vo);

	void deleteDiscount(DiscountVO vo);

	DiscountVO selectDiscount(DiscountVO vo);

	List<?> selectDiscountList(CommonDefaultVO searchVO);

	int selectDiscountListTotCnt(CommonDefaultVO searchVO);

	void insertDiscountProgram(Map<String, String> param);

	void deleteDiscountPrograms(String discountId);

	List<String> selectDiscountProgramIds(String discountId);

	List<?> selectDiscountProgramsWithValues(String discountId);

	/** 프로그램에 적용 가능한 할인 목록 */
	List<?> selectApplicableDiscounts(Map<String, String> param);

}
