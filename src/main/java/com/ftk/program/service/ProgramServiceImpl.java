package com.ftk.program.service;

import com.ftk.program.mapper.ProgramMapper;
import com.ftk.program.vo.ProgramTicketTypeVO;
import com.ftk.program.vo.ProgramDiscountVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ftk.common.vo.CommonDefaultVO;
import com.ftk.program.vo.ProgramVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;

import lombok.RequiredArgsConstructor;

/**
 * @Class Name : ProgramServiceImpl.java
 * @Description : 프로그램 서비스 구현 클래스
 */
@Service("programService")
@RequiredArgsConstructor
public class ProgramServiceImpl extends EgovAbstractServiceImpl implements ProgramService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProgramServiceImpl.class);

	private final ProgramMapper programMapper;
	private final EgovIdGnrService programIdGnrService;
	private final EgovIdGnrService programDiscountIdGnrService;

	private static final String[] DAY_TYPES = {"WEEKDAY", "SATURDAY", "SUNDAY", "HOLIDAY"};

	@Override
	public String insertProgram(ProgramVO vo) throws Exception {
		LOGGER.debug(vo.toString());

		String id = programIdGnrService.getNextStringId();
		vo.setProgramId(id);

		programMapper.insertProgram(vo);
		saveProgramTicketTypes(id, vo.getTicketTypes());
		saveProgramDiscounts(id, vo.getDiscounts());
		saveTemplates(vo);
		return id;
	}

	@Override
	public void updateProgram(ProgramVO vo) throws Exception {
		programMapper.updateProgram(vo);
		saveProgramTicketTypes(vo.getProgramId(), vo.getTicketTypes());
		saveProgramDiscounts(vo.getProgramId(), vo.getDiscounts());
		saveTemplates(vo);
	}

	@Override
	public void deleteProgram(ProgramVO vo) throws Exception {
		String programId = vo.getProgramId();
		programMapper.deleteProgramDiscounts(programId);
		programMapper.deleteProgramTicketTypes(programId);
		programMapper.deletePriceTemplates(programId);
		programMapper.deleteSessionTemplates(programId);
		programMapper.deleteProgram(vo);
	}

	@Override
	public ProgramVO selectProgram(ProgramVO vo) throws Exception {
		ProgramVO resultVO = programMapper.selectProgram(vo);
		if (resultVO == null) {
			throw processException("info.nodata.msg");
		}
		return resultVO;
	}

	@Override
	public List<?> selectProgramList(CommonDefaultVO searchVO) throws Exception {
		return programMapper.selectProgramList(searchVO);
	}

	@Override
	public int selectProgramListTotCnt(CommonDefaultVO searchVO) {
		return programMapper.selectProgramListTotCnt(searchVO);
	}

	@Override
	public List<?> selectProgramListAll() throws Exception {
		return programMapper.selectProgramListAll();
	}

	@Override
	public List<?> selectProgramListAllByType(String programType) throws Exception {
		return programMapper.selectProgramListAllByType(programType);
	}

	@Override
	public List<String> selectProgramTicketTypeIds(String programId) {
		return programMapper.selectProgramTicketTypeIds(programId);
	}

	@Override
	public List<ProgramTicketTypeVO> selectProgramTicketTypes(String programId) {
		return programMapper.selectProgramTicketTypes(programId);
	}

	@Override
	public List<ProgramDiscountVO> selectProgramDiscounts(String programId) {
		return programMapper.selectProgramDiscounts(programId);
	}

	@Override
	@SuppressWarnings("unchecked")
	public String buildTemplateJson(String programId) throws Exception {
		List<ProgramTicketTypeVO> ticketTypes = programMapper.selectProgramTicketTypes(programId);
		List<Map<String, Object>> allSessions = programMapper.selectSessionTemplates(programId);
		List<Map<String, Object>> allPrices = programMapper.selectPriceTemplates(programId);

		if (ticketTypes == null || ticketTypes.isEmpty()
				|| allSessions == null || allSessions.isEmpty()) {
			return null;
		}

		Map<String, Object> result = new LinkedHashMap<>();

		// sessions (고유 회차 목록)
		List<Map<String, Object>> sessions = new ArrayList<>();
		Set<Integer> seenSessions = new LinkedHashSet<>();
		for (Map<String, Object> s : allSessions) {
			int sessionNo = ((Number) s.get("sessionNo")).intValue();
			if (!seenSessions.contains(sessionNo)) {
				seenSessions.add(sessionNo);
				Map<String, Object> sm = new LinkedHashMap<>();
				sm.put("no", sessionNo);
				sm.put("time", s.get("eventTime"));
				sessions.add(sm);
			}
		}
		result.put("sessions", sessions);

		// ticketTypes
		List<Map<String, Object>> types = new ArrayList<>();
		for (ProgramTicketTypeVO tt : ticketTypes) {
			Map<String, Object> tm = new LinkedHashMap<>();
			tm.put("typeId", tt.getTypeId());
			tm.put("typeNm", tt.getTypeNm());
			types.add(tm);
		}
		result.put("ticketTypes", types);

		// data[dayType][sessionNo] = {enabled, types: {typeId: price}, onlineCap, offlineCap}
		Map<String, Map<String, Map<String, Object>>> data = new LinkedHashMap<>();
		for (Map<String, Object> s : allSessions) {
			String dayType = (String) s.get("dayType");
			int sessionNo = ((Number) s.get("sessionNo")).intValue();
			String enabled = s.get("enabled") != null ? s.get("enabled").toString() : "Y";
			int onlineCap = s.get("onlineCap") != null ? ((Number) s.get("onlineCap")).intValue() : 0;
			int offlineCap = s.get("offlineCap") != null ? ((Number) s.get("offlineCap")).intValue() : 0;

			data.computeIfAbsent(dayType, k -> new LinkedHashMap<>());
			Map<String, Object> entry = new LinkedHashMap<>();
			entry.put("enabled", enabled);
			entry.put("types", new LinkedHashMap<String, Object>());
			entry.put("onlineCap", onlineCap);
			entry.put("offlineCap", offlineCap);
			data.get(dayType).put(String.valueOf(sessionNo), entry);
		}

		if (allPrices != null) {
			for (Map<String, Object> p : allPrices) {
				String dayType = (String) p.get("dayType");
				int sessionNo = ((Number) p.get("sessionNo")).intValue();
				String typeId = (String) p.get("typeId");
				int price = ((Number) p.get("price")).intValue();

				if (data.containsKey(dayType)
						&& data.get(dayType).containsKey(String.valueOf(sessionNo))) {
					Map<String, Object> entry = data.get(dayType).get(String.valueOf(sessionNo));
					Map<String, Object> typesMap = (Map<String, Object>) entry.get("types");
					typesMap.put(typeId, price);
				}
			}
		}

		result.put("data", data);

		ObjectMapper mapper = new ObjectMapper();
		return mapper.writeValueAsString(result);
	}

	/**
	 * 프로그램별 권종+기본가격 저장
	 */
	private void saveProgramTicketTypes(String programId, List<ProgramTicketTypeVO> ticketTypes) {
		programMapper.deleteProgramTicketTypes(programId);
		if (ticketTypes != null) {
			int order = 0;
			for (ProgramTicketTypeVO tt : ticketTypes) {
				if (tt.getTypeId() != null && !tt.getTypeId().isEmpty()) {
					tt.setProgramId(programId);
					tt.setSortOrder(order++);
					programMapper.insertProgramTicketType(tt);
				}
			}
		}
	}

	/**
	 * 프로그램별 할인 저장
	 */
	private void saveProgramDiscounts(String programId, List<ProgramDiscountVO> discounts) throws Exception {
		programMapper.deleteProgramDiscounts(programId);
		if (discounts != null) {
			int order = 0;
			for (ProgramDiscountVO dc : discounts) {
				if (dc.getDiscountNm() != null && !dc.getDiscountNm().isEmpty()) {
					dc.setPdId(programDiscountIdGnrService.getNextStringId());
					dc.setProgramId(programId);
					dc.setSortOrder(order++);
					if (dc.getUseYn() == null || dc.getUseYn().isEmpty()) {
						dc.setUseYn("Y");
					}
					if (dc.getVerifyRequired() == null || dc.getVerifyRequired().isEmpty()) {
						dc.setVerifyRequired("N");
					}
					if (dc.getRoundingUnit() == 0) {
						dc.setRoundingUnit(1);
					}
					if (dc.getRoundingType() == null || dc.getRoundingType().isEmpty()) {
						dc.setRoundingType("ROUND");
					}
					programMapper.insertProgramDiscount(dc);
				}
			}
		}
	}

	/**
	 * 템플릿 저장: templateJson이 있으면 JSON 기반, 없으면 자동 생성
	 */
	private void saveTemplates(ProgramVO vo) {
		String programId = vo.getProgramId();
		String templateJson = vo.getTemplateJson();

		if (templateJson != null && !templateJson.trim().isEmpty()) {
			saveTemplatesFromJson(programId, templateJson);
		} else {
			generateTemplates(vo);
		}
	}

	/**
	 * JSON 데이터로부터 SESSION_TEMPLATE + PRICE_TEMPLATE 저장
	 */
	@SuppressWarnings("unchecked")
	private void saveTemplatesFromJson(String programId, String templateJson) {
		programMapper.deleteSessionTemplates(programId);
		programMapper.deletePriceTemplates(programId);

		try {
			// HTMLTagFilter가 "를 &quot;로 이스케이프하므로 원복
			String json = templateJson
					.replace("&quot;", "\"")
					.replace("&amp;", "&")
					.replace("&lt;", "<")
					.replace("&gt;", ">");

			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> root = mapper.readValue(json, Map.class);

			List<Map<String, Object>> sessions = (List<Map<String, Object>>) root.get("sessions");
			List<Map<String, Object>> types = (List<Map<String, Object>>) root.get("ticketTypes");
			Map<String, Object> dayData = (Map<String, Object>) root.get("data");

			if (sessions == null || types == null || dayData == null) {
				return;
			}

			for (Map.Entry<String, Object> dayEntry : dayData.entrySet()) {
				String dayType = dayEntry.getKey();
				Map<String, Object> sessionMap = (Map<String, Object>) dayEntry.getValue();

				for (Map<String, Object> session : sessions) {
					int sessionNo = ((Number) session.get("no")).intValue();
					String eventTime = (String) session.get("time");
					Map<String, Object> entry = (Map<String, Object>) sessionMap.get(String.valueOf(sessionNo));

					if (entry == null) continue;

					int onlineCap = entry.get("onlineCap") != null ? ((Number) entry.get("onlineCap")).intValue() : 0;
					int offlineCap = entry.get("offlineCap") != null ? ((Number) entry.get("offlineCap")).intValue() : 0;

					// SESSION_TEMPLATE
					Map<String, Object> stParam = new HashMap<>();
					stParam.put("programId", programId);
					stParam.put("sessionNo", sessionNo);
					stParam.put("dayType", dayType);
					stParam.put("eventTime", eventTime);
					stParam.put("enabled", entry.getOrDefault("enabled", "Y"));
					stParam.put("onlineCap", onlineCap);
					stParam.put("offlineCap", offlineCap);
					programMapper.insertSessionTemplate(stParam);

					// PRICE_TEMPLATE (types: {typeId: price})
					Map<String, Object> typesMap = (Map<String, Object>) entry.get("types");
					for (Map<String, Object> type : types) {
						String typeId = (String) type.get("typeId");
						int price = 0;
						if (typesMap != null && typesMap.containsKey(typeId)) {
							price = ((Number) typesMap.get(typeId)).intValue();
						}
						Map<String, Object> ptParam = new HashMap<>();
						ptParam.put("programId", programId);
						ptParam.put("sessionNo", sessionNo);
						ptParam.put("typeId", typeId);
						ptParam.put("dayType", dayType);
						ptParam.put("price", price);
						programMapper.insertPriceTemplate(ptParam);
					}
				}
			}
		} catch (Exception e) {
			LOGGER.error("템플릿 JSON 파싱 실패", e);
		}
	}

	/**
	 * 회차 설정 + 권종 기반 템플릿 자동 생성 (templateJson이 없을 때 fallback)
	 */
	private void generateTemplates(ProgramVO vo) {
		String programId = vo.getProgramId();

		programMapper.deleteSessionTemplates(programId);
		programMapper.deletePriceTemplates(programId);

		Integer sessionCount = vo.getSessionCount();
		String firstTime = vo.getFirstSessionTime();
		Integer interval = vo.getSessionInterval();

		if (sessionCount == null || sessionCount <= 0 || firstTime == null || firstTime.isEmpty()) {
			return;
		}
		if (interval == null) {
			interval = 0;
		}

		List<ProgramTicketTypeVO> ticketTypes = programMapper.selectProgramTicketTypes(programId);
		if (ticketTypes == null || ticketTypes.isEmpty()) {
			return;
		}

		String[] timeParts = firstTime.split(":");
		if (timeParts.length < 2) {
			return;
		}
		int startHour = Integer.parseInt(timeParts[0].trim());
		int startMin = Integer.parseInt(timeParts[1].trim());
		int totalMinutes = startHour * 60 + startMin;

		Integer onlineCap = vo.getDefaultOnlineCap();
		Integer offlineCap = vo.getDefaultOfflineCap();
		if (onlineCap == null) onlineCap = 0;
		if (offlineCap == null) offlineCap = 0;

		for (int sessionNo = 1; sessionNo <= sessionCount; sessionNo++) {
			String eventTime = String.format("%02d:%02d", totalMinutes / 60, totalMinutes % 60);

			for (String dayType : DAY_TYPES) {
				Map<String, Object> stParam = new HashMap<>();
				stParam.put("programId", programId);
				stParam.put("sessionNo", sessionNo);
				stParam.put("dayType", dayType);
				stParam.put("eventTime", eventTime);
				stParam.put("enabled", "Y");
				stParam.put("onlineCap", onlineCap);
				stParam.put("offlineCap", offlineCap);
				programMapper.insertSessionTemplate(stParam);

				for (ProgramTicketTypeVO tt : ticketTypes) {
					int price;
					switch (dayType) {
						case "SATURDAY":
							price = tt.getSatPrice();
							break;
						case "SUNDAY":
							price = tt.getSunPrice();
							break;
						case "HOLIDAY":
							price = tt.getHolPrice();
							break;
						default:
							price = tt.getBasePrice();
							break;
					}
					Map<String, Object> ptParam = new HashMap<>();
					ptParam.put("programId", programId);
					ptParam.put("sessionNo", sessionNo);
					ptParam.put("typeId", tt.getTypeId());
					ptParam.put("dayType", dayType);
					ptParam.put("price", price);
					programMapper.insertPriceTemplate(ptParam);
				}
			}

			totalMinutes += interval;
		}
	}

}
