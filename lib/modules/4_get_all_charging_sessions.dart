import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetAllChargingSessions extends StatefulWidget {
  const GetAllChargingSessions({super.key});

  @override
  State<GetAllChargingSessions> createState() => _GetAllChargingSessionsState();
}

class _GetAllChargingSessionsState extends State<GetAllChargingSessions> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/charging-sessions/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        'page_size': '20',
        'page': '1',
      },
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
    setState(() {});
  }
}
