import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../design-system/theme.dart';

part 'app_theme_state.dart';

class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;

  ThemeState({required this.themeData, this.isDarkMode = false});
}

class ThemeCubit extends Cubit<ThemeState> {
  bool isDarkMode = false;

  ThemeCubit() : super(ThemeState(themeData: lightTheme)) {
    _setInitialTheme();
  }

  // Get system brightness and apply the corresponding theme
  void _setInitialTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    emit(_getThemeState());
  }

  // Toggle between dark and light mode
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    emit(_getThemeState());
  }

  // Apply the theme based on whether it's dark mode or not
  ThemeState _getThemeState() {
    return ThemeState(
      themeData: isDarkMode ? DarkTheme : lightTheme,
      isDarkMode: isDarkMode,
    );
  }
}
