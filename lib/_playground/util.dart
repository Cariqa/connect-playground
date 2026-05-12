import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void logPrint(String message) {
  if (kDebugMode) {
    log(message);
  }
}

void showSnackbar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}

void initAllMenuWidget({
  required BuildContext context,
  required ScrollController scrollController,
}) {
  scrollController.jumpTo(0.01);
  if (kReleaseMode) {
    FlutterError.onError = (details) {
      logPrint('$details');
      FlutterError.presentError(details);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(details.exception.toString()),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));
    };

    PlatformDispatcher.instance.onError = (details, stack) {
      logPrint('$details');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(details.toString()),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));
      return true;
    };
  }
}
