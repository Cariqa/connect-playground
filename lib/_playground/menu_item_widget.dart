import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/global_app.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final AppTab appTab;
  final AppTab currentAppTab;
  const MenuItemWidget({
    super.key,
    required this.title,
    required this.appTab,
    required this.currentAppTab,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentAppTab == appTab;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Theme.of(context).menuBarTheme.style?.backgroundColor?.resolve({}) : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.read<PlaygroundCubit>().setTab(appTab),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).menuBarTheme.style?.surfaceTintColor?.resolve({})
                          : context.ext.menuUnselectedText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChapterWidget extends StatelessWidget {
  final String title;
  const ChapterWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 6),
      child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
    );
  }
}
