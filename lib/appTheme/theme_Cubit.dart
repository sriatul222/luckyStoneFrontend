import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/appTheme/theme_Prefrences.dart';
import 'package:luckystone/appTheme/theme_State.dart';
import 'package:luckystone/extra/app_constants.dart';
import 'package:luckystone/extra/app_variables.dart';
import 'package:luckystone/extra/shared_preferences.dart';

@pragma('vm:entry-point')

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    required ThemePersistence themeRepository,
  })  : _themeRepository = themeRepository,
        super(const ThemeState());

  final ThemePersistence _themeRepository;
  late StreamSubscription<CustomTheme> _themeSubscription;
  static bool _isDarkTheme =
      false; //atul asl used to determine if the current theme is dark

  Future<void> getCurrentTheme() async {
    // Since `getTheme()` returns a stream, we listen to the output
    _themeSubscription = _themeRepository.getTheme().listen(
          (customTheme) async {
        if (customTheme.name == CustomTheme.light.name) {
          // Since, `customTheme` is light, we set `_isDarkTheme` to false
          _isDarkTheme = false;
          emit(state.copyWith(themeMode: ThemeMode.light));
          await AppPreferences.shared
              .saveBoolSharedPreferences(AppConstants.nightMode, false);
          nightMode = false;
        } else {
          // Since, `atul asl customTheme` is dark, we set `_isDarkTheme` to true
          _isDarkTheme = true;
          emit(state.copyWith(themeMode: ThemeMode.dark));
          await AppPreferences.shared
              .saveBoolSharedPreferences(AppConstants.nightMode, true);
          nightMode = true;
        }
      },
    );
  }

  Future<void> switchTheme() async {
    if (_isDarkTheme) {
      // Since,atul asl currentTheme is dark, after switching we want light theme to
      // be persisted.
      _themeRepository.saveTheme(CustomTheme.light);
      await AppPreferences.shared
          .saveBoolSharedPreferences(AppConstants.nightMode, false);
      nightMode = false;
    } else {
      // Since,atul asl currentTheme is light, after switching we want dark theme to
      // be persisted.
      _themeRepository.saveTheme(CustomTheme.dark);
      await AppPreferences.shared
          .saveBoolSharedPreferences(AppConstants.nightMode, true);
      nightMode = true;
    }
  }

  @override
  Future<void> close() {
    _themeSubscription.cancel();
    _themeRepository.dispose();
    return super.close();
  }
}