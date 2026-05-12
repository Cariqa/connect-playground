import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaygroundCubit extends Cubit<PlaygroundState> {
  PlaygroundCubit()
      : super(
          PlaygroundState(
            appTab: AppTab.none,
            themeMode: null,
            isCredentialsSet: false,
            plainEditor: false,
          ),
        );

  void setTab(AppTab tab) {
    emit(state.copyWith(appTab: tab));
  }

  void getTheme() {
    final theme = localDb.getString('theme');
    if (theme != null) {
      emit(state.copyWith(themeMode: ThemeMode.values.firstWhere((element) => element.name == theme)));
    }
  }

  void setTheme(ThemeMode themeMode) {
    localDb.setString('theme', themeMode.name);
    emit(state.copyWith(themeMode: themeMode));
  }

  void setIsCredentialsSet() {
    emit(state.copyWith(isCredentialsSet: true));
  }

  void setPlainEditor(bool plainEditor) {
    emit(state.copyWith(plainEditor: plainEditor));
  }
}

class PlaygroundState {
  final AppTab appTab;
  final ThemeMode? themeMode;
  final bool isCredentialsSet;
  final bool plainEditor;

  PlaygroundState({
    required this.appTab,
    required this.themeMode,
    required this.isCredentialsSet,
    required this.plainEditor,
  });

  PlaygroundState copyWith({
    AppTab? appTab,
    ThemeMode? themeMode,
    bool? isCredentialsSet,
    bool? plainEditor,
  }) {
    return PlaygroundState(
      appTab: appTab ?? this.appTab,
      themeMode: themeMode ?? this.themeMode,
      isCredentialsSet: isCredentialsSet ?? this.isCredentialsSet,
      plainEditor: plainEditor ?? this.plainEditor,
    );
  }
}

class ModuleState {
  final bool? triggerCall;
  final Map<String, dynamic>? updateQueryParams;
  const ModuleState({this.triggerCall, this.updateQueryParams});
}
