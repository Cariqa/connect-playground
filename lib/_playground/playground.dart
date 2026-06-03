import 'package:connect_reference_client/_playground/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences localDb;
String? appVersion;
bool isMobile = false;
RunMode runMode = RunMode.dev;
late final http.Client globalHttpClient;

class Playground {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GoogleFonts.pendingFonts([
      GoogleFonts.robotoMono(),
      GoogleFonts.inter(),
    ]);
    localDb = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    globalHttpClient = http.Client();
    appVersion = packageInfo.version;
  }
}
