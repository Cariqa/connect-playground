import 'package:connect_reference_client/_playground/api_client.dart';
import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class StopCharging extends StatefulWidget {
  const StopCharging({super.key});

  @override
  State<StopCharging> createState() => _StopChargingState();
}

class _StopChargingState extends State<StopCharging> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/charging/stop/$sessionId/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.post,
      reqType: ReqType.body,
      pathParams: () => {
        'userId': '',
        'sessionId': '',
      },
      requestParams: () => {},
      getApiClient: (apiClient, requestParams) async {
        try {
          await apiClient.post(
            url: url,
            body: null,
            addHeaders: authorizationBearerConnectTokenHeader,
          );
        } catch (error) {
          //
          // Copy of error handling from https://docs.cariqa.com/stop-charging-errors-handling
          //

          if (error is Exception404) {
            // The requested charging session could not be found or is not accessible for the current user/client scope.
          }

          if (error is Exception409) {
            final apiError = error.body?['error'];

            switch (apiError?['type']) {
              case 'already_stopped':
              // The requested charging session is already inactive or has already been stopped.
              case 'charging_provider_error':
              // The charging provider did not successfully stop the charging session.
            }
          }

          if (error is Exception500) {
            final apiError = error.body?['error'];

            switch (apiError?['type']) {
              case 'unexpected_error':
              // An unexpected internal error occurred while processing the stop charging request.
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

    final newSessionId = pathParams['sessionId'] ?? '';
    if (newSessionId != '') sessionId = newSessionId;
    setState(() {});
  }
}
