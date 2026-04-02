import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base font family
  static String get _fontFamily => GoogleFonts.manrope().fontFamily!;

  // Light Mode Text Styles
  static TextStyle headline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle headline3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // Dark Mode Text Styles
  static TextStyle headline1Dark = headline1.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headline2Dark = headline2.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headline3Dark = headline3.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle body1Dark = body1.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle body2Dark = body2.copyWith(
    color: AppColors.textSecondaryDark,
  );

  static TextStyle captionDark = caption.copyWith(
    color: AppColors.textSecondaryDark,
  );

  static TextStyle buttonDark = button.copyWith(
    color: AppColors.textPrimaryDark,
  );
}
