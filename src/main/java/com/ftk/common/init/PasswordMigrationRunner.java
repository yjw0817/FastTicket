package com.ftk.common.init;

import java.util.List;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.ftk.common.util.CryptoUtil;
import com.ftk.member.mapper.MemberMapper;
import com.ftk.member.vo.MemberVO;

import lombok.RequiredArgsConstructor;

/**
 * 1회성 암호화 마이그레이션.
 * 마이그레이션 완료 후 이 클래스의 @Component를 제거하거나 삭제할 것.
 */
// @Component  — 마이그레이션 완료 (2026-03-06)
@RequiredArgsConstructor
public class PasswordMigrationRunner {

	private static final Logger LOGGER = LoggerFactory.getLogger(PasswordMigrationRunner.class);

	private final MemberMapper memberMapper;

	@PostConstruct
	public void migrate() {
		try {
			List<MemberVO> members = memberMapper.selectAllMembers();

			if (members.isEmpty()) {
				LOGGER.info("암호화 마이그레이션 대상 없음");
				return;
			}

			for (MemberVO member : members) {
				boolean needUpdate = false;

				// 비밀번호 마이그레이션
				if (member.getPassword() != null && !member.getPassword().startsWith("$2a$")) {
					member.setPassword(CryptoUtil.hashPassword(member.getPassword()));
					needUpdate = true;
				}

				// 전화번호 마이그레이션
				if (member.getTel() != null && !member.getTel().isEmpty()
						&& !CryptoUtil.isEncrypted(member.getTel())) {
					member.setTelLast4(CryptoUtil.extractLast4(member.getTel()));
					member.setTel(CryptoUtil.encrypt(member.getTel()));
					needUpdate = true;
				}

				if (needUpdate) {
					memberMapper.updateMember(member);
					LOGGER.info("회원 [{}] 암호화 마이그레이션 완료", member.getMemberId());
				}
			}
		} catch (Exception e) {
			LOGGER.warn("암호화 마이그레이션 실패 (테이블 미생성 시 무시 가능): {}", e.getMessage());
		}
	}

}
