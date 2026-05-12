import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuleSwitcher extends StatelessWidget {
  final String title;
  final bool showSwitcher;
  const ModuleSwitcher({super.key, required this.title, required this.showSwitcher});

  @override
  Widget build(BuildContext context) {
    final plainEditor = context.select((PlaygroundCubit bloc) => bloc.state.plainEditor);
    return Flexible(
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.ext.moduleSubtitle,
              ),
            ),
          ),
          if (showSwitcher)
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      color: plainEditor ? null : Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () => context.read<PlaygroundCubit>().setPlainEditor(false),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Text(
                          'Form',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: plainEditor ? context.ext.switcherText2 : context.ext.switcherText),
                        ),
                      ),
                    ),
                  ),
                  Ink(
                    decoration: BoxDecoration(
                      color: plainEditor ? Color(0xFFF3E8FF) : null,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () => context.read<PlaygroundCubit>().setPlainEditor(true),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Text(
                          'Raw',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: plainEditor ? context.ext.switcherText : context.ext.switcherText2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
