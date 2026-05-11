import 'package:flutter/material.dart';

class AppThemeData {
  const AppThemeData({
    required this.name,
    required this.subtitle,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.card,
    required this.text,
    required this.muted,
    required this.dark,
  });

  final String name;
  final String subtitle;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color card;
  final Color text;
  final Color muted;
  final bool dark;
}

class ThemeController extends ChangeNotifier {
  int index = 0;

  final List<AppThemeData> themes = const [
    AppThemeData(
      name: 'Classic Tech',
      subtitle: 'Blue cyber commerce',
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF7C3AED),
      accent: Color(0xFF06B6D4),
      background: Color(0xFFF6F8FF),
      surface: Colors.white,
      card: Colors.white,
      text: Color(0xFF0F172A),
      muted: Color(0xFF64748B),
      dark: false,
    ),
    AppThemeData(
      name: 'Premium Black',
      subtitle: 'Luxury dark marketplace',
      primary: Color(0xFF0F172A),
      secondary: Color(0xFFF97316),
      accent: Color(0xFFFBBF24),
      background: Color(0xFFF4F4F5),
      surface: Colors.white,
      card: Colors.white,
      text: Color(0xFF111827),
      muted: Color(0xFF6B7280),
      dark: false,
    ),
    AppThemeData(
      name: 'Neon Gradient',
      subtitle: 'Purple pink AI style',
      primary: Color(0xFF9333EA),
      secondary: Color(0xFFEC4899),
      accent: Color(0xFF22D3EE),
      background: Color(0xFFFAF5FF),
      surface: Colors.white,
      card: Colors.white,
      text: Color(0xFF1F2937),
      muted: Color(0xFF6B7280),
      dark: false,
    ),
    AppThemeData(
      name: 'Clean List',
      subtitle: 'Simple green retail',
      primary: Color(0xFF059669),
      secondary: Color(0xFF0EA5E9),
      accent: Color(0xFF84CC16),
      background: Color(0xFFF0FDF4),
      surface: Colors.white,
      card: Colors.white,
      text: Color(0xFF111827),
      muted: Color(0xFF64748B),
      dark: false,
    ),
    AppThemeData(
      name: 'Gold Future',
      subtitle: 'Luxury gold brand',
      primary: Color(0xFF92400E),
      secondary: Color(0xFFF59E0B),
      accent: Color(0xFFEF4444),
      background: Color(0xFFFFFBEB),
      surface: Colors.white,
      card: Colors.white,
      text: Color(0xFF111827),
      muted: Color(0xFF78716C),
      dark: false,
    ),
  ];

  AppThemeData get current => themes[index];

  void change(int value) {
    index = value.clamp(0, themes.length - 1);
    notifyListeners();
  }
}
