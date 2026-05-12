import 'package:connect_reference_client/_playground/cubits.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:connect_reference_client/_playground/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalApp extends StatefulWidget {
  final Widget child;
  const GlobalApp({super.key, required this.child});

  @override
  State<GlobalApp> createState() => _GlobalAppState();
}

class _GlobalAppState extends State<GlobalApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isMobile = MediaQuery.sizeOf(context).width < 500;
      context.read<PlaygroundCubit>().setTab(isMobile ? AppTab.none : AppTab.createUser);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((PlaygroundCubit cubit) => cubit.state.themeMode);
    final isCredentialsSet = context.select((PlaygroundCubit cubit) => cubit.state.isCredentialsSet);
    return MaterialApp(
      title: 'Cariqa Connect Playground',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode ?? ThemeMode.system,
      theme: ThemeData(
        extensions: [lightThemeExtensions],
        primaryColor: Colors.black,
        dividerTheme: DividerThemeData(color: dividerColor, thickness: 1.0),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.black),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        menuBarTheme: MenuBarThemeData(
          style: MenuStyle(
            surfaceTintColor: WidgetStatePropertyAll(Color(0xFF7242E4)),
            backgroundColor: WidgetStatePropertyAll(Color(0xFFEFE5FD)),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.light).textTheme)
            .copyWith(titleSmall: TextStyle(color: Color(0xFF6C7385), fontWeight: FontWeight.w400)),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black38)),
          filled: true,
          fillColor: Colors.white,
        ),
        dividerColor: dividerColor,
        snackBarTheme: SnackBarThemeData(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          contentTextStyle: TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
        ),
        textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.blue[100]),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        extensions: [darkThemeExtensions],
        primaryColor: Colors.white,
        dividerTheme: DividerThemeData(color: dividerDarkColor, thickness: 0.5),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Color(0xFF939393)),
        ),
        scaffoldBackgroundColor: darkBgColor,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white),
          backgroundColor: darkBgColor,
          foregroundColor: darkBgColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        menuBarTheme: MenuBarThemeData(
          style: MenuStyle(
            surfaceTintColor: WidgetStatePropertyAll(Color(0xFF9D80F9)),
            backgroundColor: WidgetStatePropertyAll(Color(0xFF1D1A28)),
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme)
            .copyWith(titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade700)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white70)),
          filled: true,
          fillColor: darkBgColor,
        ),
        snackBarTheme: SnackBarThemeData(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          contentTextStyle: TextStyle(color: Colors.black),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
        dividerColor: dividerDarkColor,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white, selectionColor: Colors.blue[600], selectionHandleColor: Colors.white),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: darkBgColor,
            textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  surfaceTintColor: Colors.transparent,
                  scrolledUnderElevation: 0.0,
                  toolbarHeight: 70,
                  title: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Image.asset(
                              'assets/logo_title.png',
                              height: 28,
                              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                            ),
                            SizedBox(width: 4),
                            if (isCredentialsSet) ...[
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: runMode.colorPrimary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${runMode.name.toUpperCase()} MODE',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: isMobile
                                    ? SizedBox()
                                    : Text(
                                        runMode == RunMode.test
                                            ? 'You\'re using test mode. No real transactions will be processed.'
                                            : 'You\'re using live mode. Real data will be used.',
                                        style: TextStyle(fontSize: 14),
                                      ),
                              ),
                            ] else
                              Spacer(),
                            ThemeButton(),
                            SizedBox(width: 40),
                          ],
                        ),
                        SizedBox(height: 11),
                        Container(width: double.infinity, height: 1, color: Theme.of(context).dividerColor),
                      ],
                    ),
                  ),
                ),
                body: widget.child,
              ),
              Material(
                type: MaterialType.transparency,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: Text(
                    appVersion.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

AppThemeExtensions lightThemeExtensions = AppThemeExtensions(
  secondaryColor: Color(0xFFBBBBBE),
  menuUnselectedText: Color(0xFF000000),
  tooltipBg: Color(0xFF000000),
  magicWand: Color(0xFF6B4EFF),
  moduleHeader: Color(0xFFF2F1F5),
  moduleHeaderText: Color(0xFF000000),
  modulePath: Color(0xFF555555),
  moduleSubtitle: Color(0xFF111111),
  jsonKey: Color(0xFF6B4EFF),
  jsonValue: Color(0xFF000000),
  httpStatusText: Color(0xFF555555),
  responseBody: Color(0xFF009C6A),
  httpUrl: Color(0xFFCC7F60),
  sendCall: Color(0xFF6200F9),
  switcherText: Color(0xFF6200F9),
  switcherText2: Color(0xFF000000),
);

AppThemeExtensions darkThemeExtensions = AppThemeExtensions(
  secondaryColor: Color(0xFFF1F1F1),
  menuUnselectedText: Color(0xFF98969B),
  tooltipBg: Color(0xFFFFFFFF),
  magicWand: Color(0xFFB2A4F8),
  moduleHeader: Color(0xFF222222),
  moduleHeaderText: Color(0xFFFFFFFF),
  modulePath: Color(0xFFFFFFFF),
  moduleSubtitle: Color(0xFFFFFFFF),
  jsonKey: Color(0xFF9CDCFE),
  jsonValue: Color(0xFFCE9178),
  httpStatusText: Color(0xFFFFFFFF),
  responseBody: Color(0xFFDCDCAA),
  httpUrl: Color(0xFFCE9178),
  sendCall: Color(0xFFFFFFFF),
  switcherText: Color(0xFF6200F9),
  switcherText2: Color(0xFFF1F1F1),
);

class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final Color secondaryColor;
  final Color menuUnselectedText;
  final Color moduleHeader;
  final Color moduleHeaderText;
  final Color modulePath;
  final Color moduleSubtitle;
  final Color jsonKey;
  final Color jsonValue;
  final Color httpStatusText;
  final Color responseBody;
  final Color httpUrl;
  final Color sendCall;
  final Color tooltipBg;
  final Color magicWand;
  final Color switcherText;
  final Color switcherText2;

  AppThemeExtensions({
    required this.secondaryColor,
    required this.menuUnselectedText,
    required this.moduleHeader,
    required this.moduleHeaderText,
    required this.modulePath,
    required this.moduleSubtitle,
    required this.jsonKey,
    required this.jsonValue,
    required this.httpStatusText,
    required this.responseBody,
    required this.httpUrl,
    required this.sendCall,
    required this.tooltipBg,
    required this.magicWand,
    required this.switcherText,
    required this.switcherText2,
  });

  @override
  ThemeExtension<AppThemeExtensions> copyWith() => this;

  @override
  ThemeExtension<AppThemeExtensions> lerp(covariant ThemeExtension<AppThemeExtensions>? other, double t) {
    if (other is! AppThemeExtensions) return this;
    return AppThemeExtensions(
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      menuUnselectedText: Color.lerp(menuUnselectedText, other.menuUnselectedText, t)!,
      moduleHeader: Color.lerp(moduleHeader, other.moduleHeader, t)!,
      moduleHeaderText: Color.lerp(moduleHeaderText, other.moduleHeaderText, t)!,
      modulePath: Color.lerp(modulePath, other.modulePath, t)!,
      moduleSubtitle: Color.lerp(moduleSubtitle, other.moduleSubtitle, t)!,
      jsonKey: Color.lerp(jsonKey, other.jsonKey, t)!,
      jsonValue: Color.lerp(jsonValue, other.jsonValue, t)!,
      httpStatusText: Color.lerp(httpStatusText, other.httpStatusText, t)!,
      responseBody: Color.lerp(responseBody, other.responseBody, t)!,
      httpUrl: Color.lerp(httpUrl, other.httpUrl, t)!,
      sendCall: Color.lerp(sendCall, other.sendCall, t)!,
      tooltipBg: Color.lerp(tooltipBg, other.tooltipBg, t)!,
      magicWand: Color.lerp(magicWand, other.magicWand, t)!,
      switcherText: Color.lerp(switcherText, other.switcherText, t)!,
      switcherText2: Color.lerp(switcherText2, other.switcherText2, t)!,
    );
  }
}

extension AppThemeExt on BuildContext {
  AppThemeExtensions get ext => Theme.of(this).extension<AppThemeExtensions>()!;
}

const dividerColor = Color(0xFFE2E0E5);
final dividerDarkColor = Color(0xFF353535);
const darkBgColor = Color(0xFF0F0F11);

LinearGradient menuShadowGradient(Color mainColor) => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        mainColor.withValues(alpha: 0.01),
        mainColor.withValues(alpha: 0.02),
        mainColor.withValues(alpha: 0.03),
        mainColor.withValues(alpha: 0.04),
        mainColor.withValues(alpha: 0.05),
        mainColor.withValues(alpha: 0.06),
        mainColor.withValues(alpha: 0.08),
      ],
    );
