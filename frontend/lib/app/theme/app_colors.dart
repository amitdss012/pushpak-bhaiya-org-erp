import 'package:flutter/material.dart';

/// Semantic color palette for Pushpak SaaS supporting both Light and Dark themes.
class AppColors {
  AppColors._();

  // Primary Brand Colors (Indigo / Violet)
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryHover = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFFEEF2FF); // Indigo 50
  static const Color primaryDark = Color(0xFF4338CA); // Indigo 700
  static const Color primaryContainer = Color(0xFFE0E7FF); // Indigo 100
  static const Color primaryContainerDark = Color(0xFF1E1B4B); // Indigo 950

  // Secondary Brand Accent (Teal / Cyan)
  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color secondaryLight = Color(0xFFF0F9FF);
  static const Color secondaryDark = Color(0xFF0369A1);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);

  // Light Mode Surfaces & Text
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceCardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF475569); // Slate 600
  static const Color textMutedLight = Color(0xFF94A3B8); // Slate 400

  // Dark Mode Surfaces & Text
  static const Color backgroundDark = Color(0xFF0B0F19); // Deep Slate
  static const Color surfaceDark = Color(0xFF111827); // Dark Surface
  static const Color surfaceCardDark = Color(0xFF1F2937); // Card Surface
  static const Color borderDark = Color(0xFF374151); // Dark Border
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color textMutedDark = Color(0xFF64748B); // Slate 500
}
