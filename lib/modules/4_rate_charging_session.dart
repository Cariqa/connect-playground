import 'dart:convert';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class RateChargingSession extends StatefulWidget {
  const RateChargingSession({super.key});

  @override
  State<RateChargingSession> createState() => _RateChargingSessionState();
}

class _RateChargingSessionState extends State<RateChargingSession> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/charging-sessions/$sessionId/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.patch,
      reqType: ReqType.body,
      pathParams: () => {
        'userId': '',
        'sessionId': '',
      },
      requestParams: () => {
        'rates': '5',
      },
      getApiClient: (apiClient, params) async {
        await apiClient.patch(
          url: url,
          body: jsonEncode(params),
          addHeaders: authorizationBearerConnectTokenHeader,
        );
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
