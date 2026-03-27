import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand / Primary ────────────────────────────────────────────
  static const Color primary = Color(0xFF003366);
  static const Color primaryDark = Color(0xFF002244);
  static const Color primaryLight = Color(0xFF1A5DA8);
  static const Color primaryPressed = Color(0xFF002952);
  static const Color primaryDisabled = Color(0x40003366); // 25 % opacity
  static const Color primarySurface = Color(0xFFE8EFF7); // tinted bg

  // ── Accent / CTA ───────────────────────────────────────────────
  static const Color accent = Color(0xFFF97316);
  static const Color accentDark = Color(0xFFD45E06);
  static const Color accentLight = Color(0xFFFDBA74);
  static const Color accentPressed = Color(0xFFE8660B);
  static const Color accentDisabled = Color(0x40F97316); // 25 % opacity
  static const Color accentSurface = Color(0xFFFFF3E6); // tinted bg

  // ── Surfaces ───────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F9);

  // ── Text ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  // ── Borders ────────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoBg = Color(0xFFEFF6FF);

  // ── Card accent colors ─────────────────────────────────────────
  static const Color violet = Color(0xFF6C63FF);
  static const Color teal = Color(0xFF0D9488);
  static const Color amber = Color(0xFFF59E0B);
  static const Color blue = Color(0xFF3B82F6);

  // ── Supporting tones ───────────────────────────────────────────
  static const Color skyBlue = Color(0xFF7DAEE6);
  static const Color lightBlue = Color(0xFFCBE4F7);
  static const Color peach = Color(0xFFF4C7A1);

  // ── Interaction (mobile press) ─────────────────────────────────
  static const Color pressed = Color(0xFFE2E8F0);
  static const Color ripple = Color(0x1A003366); // 10 % primary
}
