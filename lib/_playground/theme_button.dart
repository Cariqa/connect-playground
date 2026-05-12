import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.select((PlaygroundCubit cubit) => cubit.state.themeMode);
    final themeModeLight = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isLight = theme != null ? ThemeMode.light == theme : themeModeLight == Brightness.light;

    return IconButton(
      onPressed: () => context.read<PlaygroundCubit>().setTheme(isLight ? ThemeMode.dark : ThemeMode.light),
      icon: Icon(
        isLight ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: isLight ? Colors.black : Colors.white,
      ),
    );
  }
}
