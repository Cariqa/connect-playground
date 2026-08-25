import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class SoftDeleteUser extends StatefulWidget {
  const SoftDeleteUser({super.key});

  @override
  State<SoftDeleteUser> createState() => _SoftDeleteUserState();
}

class _SoftDeleteUserState extends State<SoftDeleteUser> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.delete,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {},
      getApiClient: (apiClient, requestParams) async {
        await apiClient.delete(
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
