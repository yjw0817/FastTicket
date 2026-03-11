package com.ftk.discount.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ftk.discount.mapper.DiscountMapper;
import com.ftk.discount.vo.DiscountVO;
import com.ftk.common.vo.CommonDefaultVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import lombok.RequiredArgsConstructor;

@Service("discountService")
@RequiredArgsConstructor
public class DiscountServiceImpl extends EgovAbstractServiceImpl implements DiscountService {

	private final DiscountMapper discountMapper;
	private final EgovIdGnrService discountIdGnrService;

	@Override
	public String insertDiscount(DiscountVO vo) throws Exception {
		String id = discountIdGnrService.getNextStringId();
		vo.setDiscountId(id);
		if (vo.getUseYn() == null || vo.getUseYn().isEmpty()) {
			vo.setUseYn("Y");
		}
		if (vo.getRoundingUnit() <= 0) {
			vo.setRoundingUnit(1);
		}
		if (vo.getRoundingType() == null || vo.getRoundingType().isEmpty()) {
			vo.setRoundingType("ROUND");
		}
		discountMapper.insertDiscount(vo);
		saveDiscountPrograms(id, vo.getProgramIds(), vo.getProgramValues());
		return id;
	}

	@Override
	public void updateDiscount(DiscountVO vo) throws Exception {
		if (vo.getUseYn() == null || vo.getUseYn().isEmpty()) {
			vo.setUseYn("Y");
		}
		if (vo.getRoundingUnit() <= 0) {
			vo.setRoundingUnit(1);
		}
		if (vo.getRoundingType() == null || vo.getRoundingType().isEmpty()) {
			vo.setRoundingType("ROUND");
		}
		discountMapper.updateDiscount(vo);
		saveDiscountPrograms(vo.getDiscountId(), vo.getProgramIds(), vo.getProgramValues());
	}

	@Override
	public void deleteDiscount(DiscountVO vo) throws Exception {
		discountMapper.deleteDiscount(vo);
	}

	@Override
	public DiscountVO selectDiscount(DiscountVO vo) throws Exception {
		return discountMapper.selectDiscount(vo);
	}

	@Override
	public List<?> selectDiscountList(CommonDefaultVO searchVO) throws Exception {
		return discountMapper.selectDiscountList(searchVO);
	}

	@Override
	public int selectDiscountListTotCnt(CommonDefaultVO searchVO) {
		return discountMapper.selectDiscountListTotCnt(searchVO);
	}

	@Override
	public List<String> selectDiscountProgramIds(String discountId) {
		return discountMapper.selectDiscountProgramIds(discountId);
	}

	@Override
	public List<?> selectDiscountProgramsWithValues(String discountId) {
		return discountMapper.selectDiscountProgramsWithValues(discountId);
	}

	@Override
	public List<?> selectApplicableDiscounts(String programId, String eventDate) {
		Map<String, String> param = new HashMap<>();
		param.put("programId", programId);
		param.put("eventDate", eventDate);
		return discountMapper.selectApplicableDiscounts(param);
	}

	private void saveDiscountPrograms(String discountId, List<String> programIds, List<String> programValues) {
		discountMapper.deleteDiscountPrograms(discountId);
		if (programIds != null) {
			for (int i = 0; i < programIds.size(); i++) {
				String programId = programIds.get(i);
				if (programId != null && !programId.isEmpty()) {
					Map<String, String> param = new HashMap<>();
					param.put("discountId", discountId);
					param.put("programId", programId);
					String overrideVal = (programValues != null && i < programValues.size()) ? programValues.get(i) : null;
					param.put("discountValue", (overrideVal != null && !overrideVal.isEmpty()) ? overrideVal : null);
					discountMapper.insertDiscountProgram(param);
				}
			}
		}
	}

}
