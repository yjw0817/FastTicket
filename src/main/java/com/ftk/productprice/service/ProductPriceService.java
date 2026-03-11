package com.ftk.productprice.service;

import java.util.List;

import com.ftk.productprice.vo.ProductPriceVO;

/**
 * @Class Name : ProductPriceService.java
 * @Description : 상품 가격 서비스 인터페이스
 */
public interface ProductPriceService {

	String insertProductPrice(ProductPriceVO vo) throws Exception;

	void updateProductPrice(ProductPriceVO vo) throws Exception;

	void deleteProductPrice(ProductPriceVO vo) throws Exception;

	ProductPriceVO selectProductPrice(ProductPriceVO vo) throws Exception;

	List<ProductPriceVO> selectProductPriceListByProgram(String programId) throws Exception;

	void deleteProductPriceByProgram(String programId) throws Exception;

}
