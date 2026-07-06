import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppFontFamilies {
  const AppFontFamilies._();

  static const playfairDisplay = 'Playfair Display';
  static const inter = 'Inter';
}

class AppTextStyles {
  const AppTextStyles._();

  static const headlineLg = TextStyle(
    fontFamily: AppFontFamilies.playfairDisplay,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    height: 48 / 40,
    letterSpacing: -0.8,
    color: AppColors.onSurface,
  );

  static const headlineLgMobile = TextStyle(
    fontFamily: AppFontFamilies.playfairDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.32,
    color: AppColors.onSurface,
  );

  static const headlineMd = TextStyle(
    fontFamily: AppFontFamilies.playfairDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    color: AppColors.onSurface,
  );

  static const bodyLg = TextStyle(
    fontFamily: AppFontFamilies.inter,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: AppColors.onSurface,
  );

  static const bodyMd = TextStyle(
    fontFamily: AppFontFamilies.inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static const labelMd = TextStyle(
    fontFamily: AppFontFamilies.inter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.7,
    color: AppColors.onSurfaceVariant,
  );

  static const numberXl = TextStyle(
    fontFamily: AppFontFamilies.inter,
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 56 / 48,
    letterSpacing: -1.92,
    color: AppColors.onSurface,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const numberMd = TextStyle(
    fontFamily: AppFontFamilies.inter,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 24 / 20,
    color: AppColors.onSurface,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
