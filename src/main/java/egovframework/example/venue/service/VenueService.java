package egovframework.example.venue.service;

import java.util.List;

import egovframework.example.cmmn.service.CommonDefaultVO;

/**
 * @Class Name : VenueService.java
 * @Description : 공연장 서비스 인터페이스
 */
public interface VenueService {

	/**
	 * 공연장을 등록한다.
	 * @param vo - 등록할 정보가 담긴 VenueVO
	 * @return 등록된 공연장ID
	 * @exception Exception
	 */
	String insertVenue(VenueVO vo) throws Exception;

	/**
	 * 공연장을 수정한다.
	 * @param vo - 수정할 정보가 담긴 VenueVO
	 * @exception Exception
	 */
	void updateVenue(VenueVO vo) throws Exception;

	/**
	 * 공연장을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 VenueVO
	 * @exception Exception
	 */
	void deleteVenue(VenueVO vo) throws Exception;

	/**
	 * 공연장을 조회한다.
	 * @param vo - 조회할 정보가 담긴 VenueVO
	 * @return 조회한 공연장
	 * @exception Exception
	 */
	VenueVO selectVenue(VenueVO vo) throws Exception;

	/**
	 * 공연장 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연장 목록
	 * @exception Exception
	 */
	List<?> selectVenueList(CommonDefaultVO searchVO) throws Exception;

	/**
	 * 공연장 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연장 총 갯수
	 */
	int selectVenueListTotCnt(CommonDefaultVO searchVO);

}
