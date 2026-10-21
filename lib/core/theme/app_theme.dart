import 'package:flutter/material.dart';

/// Spacing scale (logical pixels).
abstract final class Gap {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Semantic status colours used for chips and indicators, tuned for contrast
/// in both themes.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.danger,
    required this.onDanger,
    required this.info,
    required this.onInfo,
    required this.neutral,
    required this.onNeutral,
  });

  final Color success, onSuccess, warning, onWarning, danger, onDanger;
  final Color info, onInfo, neutral, onNeutral;

  static const light = StatusColors(
    success: Color(0xFFDDF3E4),
    onSuccess: Color(0xFF0B5D2A),
    warning: Color(0xFFFFF0D1),
    onWarning: Color(0xFF7A4A00),
    danger: Color(0xFFFDE2E1),
    onDanger: Color(0xFF9B1C1C),
    info: Color(0xFFDDEBFF),
    onInfo: Color(0xFF0B3D91),
    neutral: Color(0xFFECEFF3),
    onNeutral: Color(0xFF3A4350),
  );

  static const dark = StatusColors(
    success: Color(0xFF123D24),
    onSuccess: Color(0xFFA6E9BE),
    warning: Color(0xFF4A3507),
    onWarning: Color(0xFFFFD98A),
    danger: Color(0xFF4D1717),
    onDanger: Color(0xFFFFB4B0),
    info: Color(0xFF13305F),
    onInfo: Color(0xFFB7D2FF),
    neutral: Color(0xFF2B3139),
    onNeutral: Color(0xFFC9D1DB),
  );

  @override
  StatusColors copyWith() => this;

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) =>
      t < 0.5 ? this : (other as StatusColors? ?? this);
}

abstract final class AppTheme {
  static const seed = Color(0xFF1F5FAD); // dependable blue

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: b,
      surface: b == Brightness.light ? const Color(0xFFFFFFFF) : null,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: b,
    );
    final text = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final radius = BorderRadius.circular(12);
    return base.copyWith(
      scaffoldBackgroundColor: b == Brightness.light
          ? const Color(0xFFF4F6F9)
          : scheme.surface,
      textTheme: text.copyWith(
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 15),
        labelLarge: text.labelLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      extensions: [
        b == Brightness.light ? StatusColors.light : StatusColors.dark,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: b == Brightness.light
            ? Colors.white
            : scheme.surfaceContainerHigh,
        border: OutlineInputBorder(borderRadius: radius),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outline),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: text.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: text.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        extendedTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(
          text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        minVerticalPadding: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: Gap.lg),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: text.labelLarge?.copyWith(fontSize: 14),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    );
  }
}

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  StatusColors get status => Theme.of(this).extension<StatusColors>()!;
}
