import 'dart:convert';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.patch,
      reqType: ReqType.body,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        'email': null,
        'locale': 'en',
        'custom_properties': {
          'external_id': 'my-external-id-1',
        }
      },
      getApiClient: (apiClient, requestParams) async {
        await apiClient.patch(
          url: url,
          body: jsonEncode(requestParams),
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
