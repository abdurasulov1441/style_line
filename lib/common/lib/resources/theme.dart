import 'package:common/resources/typography.dart';
import 'package:flutter/material.dart';

final class MapkitFlutterTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.blue[400]!,
      onSecondary: Colors.blue[400]!.withOpacity(0.7),
      tertiary: Colors.blue[400]!,
      onTertiary: Colors.grey,
      error: Colors.red,
      onError: Colors.redAccent,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    textTheme: MapkitFlutterTypography.textTheme,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.blue[400]!,
      onSecondary: Colors.blue[400]!.withOpacity(0.7),
      tertiary: Colors.white,
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.redAccent,
      surface: Colors.grey[850]!,
      onSurface: Colors.white,
    ),
    textTheme: MapkitFlutterTypography.textTheme,
  );
}
