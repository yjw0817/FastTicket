package com.ftk.common.util;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 암호화 유틸리티
 * - 비밀번호: BCrypt (단방향)
 * - 전화번호: AES-256-GCM (양방향)
 *
 * AES 키는 crypto.properties에서 Spring Bean 주입으로 받는다.
 */
public class CryptoUtil {

	private static final BCryptPasswordEncoder BCRYPT = new BCryptPasswordEncoder();

	private static final String AES_ALGORITHM = "AES/GCM/NoPadding";
	private static final int GCM_IV_LENGTH = 12;
	private static final int GCM_TAG_LENGTH = 128;

	/** Spring에서 주입받은 인스턴스를 static으로 접근하기 위한 홀더 */
	private static CryptoUtil instance;

	private final String aesKey;

	public CryptoUtil(String aesKey) {
		this.aesKey = aesKey;
	}

	@PostConstruct
	public void init() {
		instance = this;
	}

	// ========== BCrypt (비밀번호) ==========

	public static String hashPassword(String rawPassword) {
		return BCRYPT.encode(rawPassword);
	}

	public static boolean matchPassword(String rawPassword, String encodedPassword) {
		// BCrypt 해시가 아닌 평문이면 직접 비교 (마이그레이션 전 데이터 호환)
		if (encodedPassword != null && !encodedPassword.startsWith("$2a$")) {
			return rawPassword.equals(encodedPassword);
		}
		return BCRYPT.matches(rawPassword, encodedPassword);
	}

	// ========== AES-256-GCM (전화번호) ==========

	public static String encrypt(String plainText) {
		if (plainText == null || plainText.isEmpty()) {
			return plainText;
		}
		try {
			byte[] keyBytes = instance.aesKey.getBytes(StandardCharsets.UTF_8);
			byte[] iv = new byte[GCM_IV_LENGTH];
			new SecureRandom().nextBytes(iv);

			SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
			GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);

			Cipher cipher = Cipher.getInstance(AES_ALGORITHM);
			cipher.init(Cipher.ENCRYPT_MODE, keySpec, gcmSpec);
			byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

			byte[] combined = new byte[iv.length + encrypted.length];
			System.arraycopy(iv, 0, combined, 0, iv.length);
			System.arraycopy(encrypted, 0, combined, iv.length, encrypted.length);

			return Base64.getEncoder().encodeToString(combined);
		} catch (Exception e) {
			throw new RuntimeException("AES 암호화 실패", e);
		}
	}

	/** 암호화된 값인지 판별 (Base64 형식 + 최소 길이) */
	public static boolean isEncrypted(String text) {
		if (text == null || text.length() < 20) {
			return false;
		}
		return text.matches("^[A-Za-z0-9+/=]+$");
	}

	public static String decrypt(String encryptedText) {
		if (encryptedText == null || encryptedText.isEmpty()) {
			return encryptedText;
		}
		// 암호화되지 않은 평문이면 그대로 반환 (마이그레이션 전 데이터 호환)
		if (!isEncrypted(encryptedText)) {
			return encryptedText;
		}
		try {
			byte[] keyBytes = instance.aesKey.getBytes(StandardCharsets.UTF_8);
			byte[] combined = Base64.getDecoder().decode(encryptedText);

			byte[] iv = new byte[GCM_IV_LENGTH];
			System.arraycopy(combined, 0, iv, 0, iv.length);

			byte[] encrypted = new byte[combined.length - iv.length];
			System.arraycopy(combined, iv.length, encrypted, 0, encrypted.length);

			SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
			GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);

			Cipher cipher = Cipher.getInstance(AES_ALGORITHM);
			cipher.init(Cipher.DECRYPT_MODE, keySpec, gcmSpec);

			return new String(cipher.doFinal(encrypted), StandardCharsets.UTF_8);
		} catch (Exception e) {
			throw new RuntimeException("AES 복호화 실패", e);
		}
	}

	/** 전화번호에서 뒷번호 4자리 추출 */
	public static String extractLast4(String tel) {
		if (tel == null || tel.isEmpty()) {
			return "";
		}
		String digitsOnly = tel.replaceAll("[^0-9]", "");
		if (digitsOnly.length() < 4) {
			return digitsOnly;
		}
		return digitsOnly.substring(digitsOnly.length() - 4);
	}

}
