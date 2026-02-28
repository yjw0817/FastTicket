package egovframework.example.venue.service.impl;

import java.util.List;

import egovframework.example.venue.service.VenueService;
import egovframework.example.venue.service.VenueVO;
import egovframework.example.cmmn.service.CommonDefaultVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @Class Name : VenueServiceImpl.java
 * @Description : 공연장 서비스 구현 클래스
 */
@Service("venueService")
public class VenueServiceImpl extends EgovAbstractServiceImpl implements VenueService {

	private static final Logger LOGGER = LoggerFactory.getLogger(VenueServiceImpl.class);

	/** VenueMapper */
	@Resource(name = "venueMapper")
	private VenueMapper venueMapper;

	/** ID Generation */
	@Resource(name = "venueIdGnrService")
	private EgovIdGnrService venueIdGnrService;

	/**
	 * 공연장을 등록한다.
	 * @param vo - 등록할 정보가 담긴 VenueVO
	 * @return 등록된 공연장ID
	 * @exception Exception
	 */
	@Override
	public String insertVenue(VenueVO vo) throws Exception {
		LOGGER.debug(vo.toString());
		String id = venueIdGnrService.getNextStringId();
		vo.setVenueId(id);
		LOGGER.debug(vo.toString());
		venueMapper.insertVenue(vo);
		return id;
	}

	/**
	 * 공연장을 수정한다.
	 * @param vo - 수정할 정보가 담긴 VenueVO
	 * @exception Exception
	 */
	@Override
	public void updateVenue(VenueVO vo) throws Exception {
		venueMapper.updateVenue(vo);
	}

	/**
	 * 공연장을 삭제한다.
	 * @param vo - 삭제할 정보가 담긴 VenueVO
	 * @exception Exception
	 */
	@Override
	public void deleteVenue(VenueVO vo) throws Exception {
		venueMapper.deleteVenue(vo);
	}

	/**
	 * 공연장을 조회한다.
	 * @param vo - 조회할 정보가 담긴 VenueVO
	 * @return 조회한 공연장
	 * @exception Exception
	 */
	@Override
	public VenueVO selectVenue(VenueVO vo) throws Exception {
		VenueVO resultVO = venueMapper.selectVenue(vo);
		if (resultVO == null)
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 공연장 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연장 목록
	 * @exception Exception
	 */
	@Override
	public List<?> selectVenueList(CommonDefaultVO searchVO) throws Exception {
		return venueMapper.selectVenueList(searchVO);
	}

	/**
	 * 공연장 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 공연장 총 갯수
	 */
	@Override
	public int selectVenueListTotCnt(CommonDefaultVO searchVO) {
		return venueMapper.selectVenueListTotCnt(searchVO);
	}

}
