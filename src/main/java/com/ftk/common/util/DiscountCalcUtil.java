package com.ftk.common.util;

/**
 * 할인 계산 유틸리티
 * - 정률(PERCENT) / 정액(AMOUNT) 할인 계산
 * - 반올림 단위/방식 적용
 */
public class DiscountCalcUtil {

	private DiscountCalcUtil() {}

	/**
	 * 할인 적용 후 최종 가격 계산
	 *
	 * @param originalPrice 원래 가격
	 * @param discountType  할인 유형 (PERCENT / AMOUNT)
	 * @param discountValue 할인값 (PERCENT면 %, AMOUNT면 원)
	 * @param roundingUnit  반올림 단위 (1, 10, 100, 1000)
	 * @param roundingType  반올림 방식 (ROUND, CEIL, FLOOR)
	 * @return 할인 적용 후 가격 (음수 방지, 최소 0)
	 */
	public static int calculateDiscountedPrice(int originalPrice, String discountType,
			int discountValue, int roundingUnit, String roundingType) {

		if (originalPrice <= 0 || discountValue <= 0) {
			return Math.max(originalPrice, 0);
		}

		double result;

		if ("AMOUNT".equals(discountType)) {
			result = originalPrice - discountValue;
		} else {
			// PERCENT
			result = originalPrice * (1.0 - discountValue / 100.0);
		}

		if (result <= 0) {
			return 0;
		}

		// 반올림 적용 (정액일 때도 결과가 정수이므로 사실상 무영향이지만 일관성 유지)
		result = applyRounding(result, roundingUnit, roundingType);

		return Math.max((int) result, 0);
	}

	/**
	 * 반올림 적용
	 */
	public static double applyRounding(double value, int roundingUnit, String roundingType) {
		if (roundingUnit <= 1) {
			roundingUnit = 1;
		}
		if (roundingType == null) {
			roundingType = "ROUND";
		}

		switch (roundingType) {
			case "CEIL":
				return Math.ceil(value / roundingUnit) * roundingUnit;
			case "FLOOR":
				return Math.floor(value / roundingUnit) * roundingUnit;
			default: // ROUND
				return Math.round(value / (double) roundingUnit) * roundingUnit;
		}
	}

	/**
	 * 할인액 계산 (원래가격 - 할인후가격)
	 */
	public static int calculateDiscountAmount(int originalPrice, String discountType,
			int discountValue, int roundingUnit, String roundingType) {
		int discounted = calculateDiscountedPrice(originalPrice, discountType,
				discountValue, roundingUnit, roundingType);
		return originalPrice - discounted;
	}

}
