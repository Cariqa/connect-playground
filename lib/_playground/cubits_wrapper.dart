import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitsWrapper extends StatelessWidget {
  final Widget child;
  const CubitsWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaygroundCubit>(create: (ctx) => PlaygroundCubit()..getTheme()),
      ],
      child: child,
    );
  }
}
