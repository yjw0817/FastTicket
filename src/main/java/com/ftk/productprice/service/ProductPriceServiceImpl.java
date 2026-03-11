package com.ftk.productprice.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ftk.productprice.mapper.ProductPriceMapper;
import com.ftk.productprice.vo.ProductPriceVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : ProductPriceServiceImpl.java
 * @Description : 상품 가격 서비스 구현
 */
@Service("productPriceService")
@RequiredArgsConstructor
public class ProductPriceServiceImpl extends EgovAbstractServiceImpl implements ProductPriceService {

	private final ProductPriceMapper productPriceMapper;
	private final EgovIdGnrService productPriceIdGnrService;

	@Override
	public String insertProductPrice(ProductPriceVO vo) throws Exception {
		String id = productPriceIdGnrService.getNextStringId();
		vo.setPpriceId(id);
		productPriceMapper.insertProductPrice(vo);
		return id;
	}

	@Override
	public void updateProductPrice(ProductPriceVO vo) throws Exception {
		productPriceMapper.updateProductPrice(vo);
	}

	@Override
	public void deleteProductPrice(ProductPriceVO vo) throws Exception {
		productPriceMapper.deleteProductPrice(vo);
	}

	@Override
	public ProductPriceVO selectProductPrice(ProductPriceVO vo) throws Exception {
		return productPriceMapper.selectProductPrice(vo);
	}

	@Override
	public List<ProductPriceVO> selectProductPriceListByProgram(String programId) throws Exception {
		return productPriceMapper.selectProductPriceListByProgram(programId);
	}

	@Override
	public void deleteProductPriceByProgram(String programId) throws Exception {
		productPriceMapper.deleteProductPriceByProgram(programId);
	}

}
