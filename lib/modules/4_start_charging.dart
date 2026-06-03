import 'dart:convert';

import 'package:connect_reference_client/_playground/api_client.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:connect_reference_client/payments_mobile.dart'
    if (dart.library.js) 'package:connect_reference_client/payments_web.dart' as MOBILE_or_WEB_PAYMENTS;
import 'package:flutter/material.dart';

class StartCharging extends StatefulWidget {
  const StartCharging({super.key});

  @override
  State<StartCharging> createState() => _StartChargingState();
}

class _StartChargingState extends State<StartCharging> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/charging/start/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.post,
      reqType: ReqType.body,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        "evse_id": '',
        "payment_method_id": '',
      },
      getApiClient: (apiClient, params) async {
        try {
          final res = await apiClient.post(
            url: url,
            body: jsonEncode(params),
            addHeaders: authorizationBearerConnectTokenHeader,
          );
          sessionId = res['id'];
        } catch (error) {
          if (error is Exception402) {
            final apiError = error.body?['error'];

            if (apiError?['type'] == 'pre_authorization_failed') {
              final paymentIntentClientSecret = apiError['payment_intent_client_secret'];

              if (paymentIntentClientSecret != null) {
                MOBILE_or_WEB_PAYMENTS.confirmPayment(
                  paymentIntentClientSecret: paymentIntentClientSecret,
                  paymentMethodId: paymentMethodId!,
                );
              }
            }
          }
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
