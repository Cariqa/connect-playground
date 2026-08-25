import 'dart:convert';

import 'package:connect_reference_client/_playground/api_client.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:connect_reference_client/payments_android.dart';
import 'package:connect_reference_client/payments_ios.dart';
import 'package:connect_reference_client/payments_web.dart';
import 'package:flutter/foundation.dart';
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
      getApiClient: (apiClient, requestParams) async {
        try {
          final res = await apiClient.post(
            url: url,
            body: jsonEncode(requestParams),
            addHeaders: authorizationBearerConnectTokenHeader,
          );
          sessionId = res['id'];
        } catch (error) {
          //
          // Copy of error handling from https://docs.cariqa.com/start-charging-errors-handling:
          //

          if (error is Exception402) {
            final apiError = error.body?['error'];

            switch (apiError?['type']) {
              // The platform could not pre-authorize the customer’s payment method before starting the charging session.
              case 'pre_authorization_failed':
                final paymentIntentClientSecret = apiError['payment_intent_client_secret'];
                if (paymentIntentClientSecret != null) {
                  // Web:
                  if (kIsWeb) {
                    confirmPaymentWeb(
                      paymentIntentClientSecret: paymentIntentClientSecret,
                      paymentMethodId: paymentMethodId!,
                    );
                  }

                  // iOS:
                  if (isMobileIos) {
                    confirmPaymentIos(
                      paymentIntentClientSecret: paymentIntentClientSecret,
                      paymentMethodId: paymentMethodId!,
                    );
                  }

                  // Android
                  if (isMobileAndroid) {
                    confirmPaymentAndroid(
                      paymentIntentClientSecret: paymentIntentClientSecret,
                      paymentMethodId: paymentMethodId!,
                    );
                  }
                }
              case 'payment_error':
              // The customer has an outstanding unpaid charging session or payment that must be completed before a
              // new session can start.
            }
          }

          if (error is Exception404) {
            // The requested station or EVSE could not be found.
          }

          if (error is Exception409) {
            final apiError = error.body?['error'];

            switch (apiError?['type']) {
              case 'already_charging':
              // The customer already has an active charging session, or another start charging request is already being processed.

              case 'billing_data_required':
              // The customer’s billing data is missing, incomplete, or incorrectly configured.

              case 'station_availability_issue':
              // The selected connector is out of order.
            }
          }

          if (error is Exception424) {
            final apiError = error.body?['error'];

            switch (apiError?['type']) {
              case 'station_availability_issue':
              // The platform could not fetch or validate station data.

              case 'charging_provider_error':
              // The charging provider did not successfully start the charging session.
            }
          }

          if (error is Exception500) {
            final apiError = error.body?['error'];

            switch (apiError?['type']) {
              case 'unexpected_error':
              // An unexpected internal error occurred while processing the start charging request.
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
