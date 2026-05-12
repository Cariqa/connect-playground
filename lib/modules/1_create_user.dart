import 'dart:convert';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatelessWidget {
  const CreateUser({super.key});

  @override
  Widget build(BuildContext context) {
    final url = '/users/';
    return ModuleWidget(
      apiType: ApiType.post,
      urlName: url,
      reqType: ReqType.body,
      requestParams: () => {
        'email': null,
        'locale': 'en',
        'custom_properties': {
          'external_id': 'my-external-id-1',
        }
      },
      getApiClient: (apiClient, params) async {
        final user = await apiClient.post(
          url: url,
          body: jsonEncode(params),
          addHeaders: authorizationBearerConnectTokenHeader,
        );
        userId = user['id'];
      },
    );
  }
}
