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
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? Theme.of(context).menuBarTheme.style?.surfaceTintColor?.resolve({})
                    : context.ext.menuUnselectedText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChapterWidget extends StatelessWidget {
  final String title;
  final AppChapter appChapter;
  final List<Widget> submodules;

  const ChapterWidget({super.key, required this.title, required this.appChapter, required this.submodules});

  @override
  Widget build(BuildContext context) {
    final currentAppChapter = context.select((PlaygroundCubit cubit) => cubit.state.appChapter);
    final isCurrentSelected = appChapter == currentAppChapter;
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            splashFactory: NoSplash.splashFactory,
            onTap: () => context.read<PlaygroundCubit>().setChapter(appChapter),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 0, 14),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        title[0],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isCurrentSelected
                              ? Theme.of(context).menuBarTheme.style?.surfaceTintColor?.resolve({})
                              : context.ext.menuUnselectedText,
                        ),
                      ),
                    ),
                    Text(
                      title.replaceRange(0, 1, ''),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCurrentSelected
                            ? Theme.of(context).menuBarTheme.style?.surfaceTintColor?.resolve({})
                            : context.ext.menuUnselectedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isCurrentSelected) SizedBox(height: 10),
          if (isCurrentSelected) ...submodules,
        ],
      ),
    );
  }
}
