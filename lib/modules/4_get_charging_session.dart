import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetChargingSession extends StatefulWidget {
  const GetChargingSession({super.key});

  @override
  State<GetChargingSession> createState() => _GetChargingSessionState();
}

class _GetChargingSessionState extends State<GetChargingSession> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/charging-sessions/$sessionId/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      pathParams: () => {
        'userId': '',
        'sessionId': '',
      },
      requestParams: () => {},
      getApiClient: (apiClient, params) async {
        await apiClient.get(
          url: url,
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
