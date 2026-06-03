import 'dart:io';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:connect_reference_client/payments_mobile.dart'
    if (dart.library.js) 'package:connect_reference_client/payments_web.dart' as MOBILE_or_WEB_PAYMENTS;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/setup-intents/';

    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        'pm_type': 'card',
      },
      getApiClient: (apiClient, params) async {
        final res = await apiClient.get(
          url: url,
          params: params,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        // Web:
        if (kIsWeb) {
          MOBILE_or_WEB_PAYMENTS.addPaymentMethod(context, res['setup_intent_client_secret']);
        }

        // Mobile:
        if (kIsWeb == false && Platform.isIOS) {
          MOBILE_or_WEB_PAYMENTS.addIosPaymentMethod(context, res['setup_intent_client_secret']);
        }
        if (kIsWeb == false && Platform.isAndroid) {
          MOBILE_or_WEB_PAYMENTS.addAndroidPaymentMethod(context, res['setup_intent_client_secret']);
        }
      },
      onPathChange: _playgroundEditorPathChange,
    );
  }

  void _playgroundEditorPathChange(Map<String, dynamic> pathParams) {
    final newPathUser = pathParams['userId'] ?? '';
    if (newPathUser != '') userId = newPathUser;
    setState(() {});
  }
}
