package com.ftk.productprice.mapper;

import java.util.List;

import com.ftk.productprice.vo.ProductPriceVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * @Class Name : ProductPriceMapper.java
 * @Description : 상품 가격 MyBatis Mapper
 */
@Mapper("productPriceMapper")
public interface ProductPriceMapper {

	void insertProductPrice(ProductPriceVO vo) throws Exception;

	void updateProductPrice(ProductPriceVO vo) throws Exception;

	void deleteProductPrice(ProductPriceVO vo) throws Exception;

	ProductPriceVO selectProductPrice(ProductPriceVO vo) throws Exception;

	/** 특정 프로그램의 상품 가격 목록 */
	List<ProductPriceVO> selectProductPriceListByProgram(String programId) throws Exception;

	/** 특정 프로그램의 상품 가격 전체 삭제 */
	void deleteProductPriceByProgram(String programId) throws Exception;

}
