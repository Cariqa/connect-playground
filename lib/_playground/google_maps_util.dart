import 'package:connect_reference_client/_playground/mocked_web_lib.dart' if (dart.library.js) 'package:web/web.dart'
    as web_lib;
import 'package:connect_reference_client/_playground/util.dart';
import 'package:connect_reference_client/main.dart';

void appendGoogleMapScriptHtml() {
  try {
    final meta = web_lib.HTMLScriptElement();
    meta.src = 'https://maps.googleapis.com/maps/api/js?key=$googleMapApiKey';

    web_lib.document.head?.append(meta);
  } catch (e, st) {
    logPrint('$e $st');
  }
}
