import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetUser extends StatefulWidget {
  const GetUser({super.key});

  @override
  State<GetUser> createState() => _GetUserState();
}

class _GetUserState extends State<GetUser> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {},
      getApiClient: (apiClient, requestParams) async {
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
