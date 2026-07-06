import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          textStyle: AppTextStyles.headlineLg,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          textStyle: AppTextStyles.headlineLgMobile,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          textStyle: AppTextStyles.headlineMd,
        ),
        bodyLarge: GoogleFonts.inter(textStyle: AppTextStyles.bodyLg),
        bodyMedium: GoogleFonts.inter(textStyle: AppTextStyles.bodyMd),
        labelMedium: GoogleFonts.inter(textStyle: AppTextStyles.labelMd),
        titleLarge: GoogleFonts.inter(textStyle: AppTextStyles.numberMd),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: GoogleFonts.playfairDisplay(
          textStyle: AppTextStyles.headlineMd,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceContainerLowest,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        labelStyle: GoogleFonts.inter(textStyle: AppTextStyles.labelMd),
        floatingLabelStyle: GoogleFonts.inter(
          textStyle: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(44, 44),
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.standard),
          ),
          textStyle: GoogleFonts.inter(textStyle: AppTextStyles.labelMd),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(44, 44),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.standard),
          ),
          textStyle: GoogleFonts.inter(textStyle: AppTextStyles.labelMd),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          foregroundColor: AppColors.secondary,
          textStyle: GoogleFonts.inter(textStyle: AppTextStyles.labelMd),
        ),
      ),
    );
  }
}
