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
      getApiClient: (apiClient, params) async {
        await apiClient.post(
          url: url,
          body: null,
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
