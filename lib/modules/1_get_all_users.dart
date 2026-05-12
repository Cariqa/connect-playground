import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetAllUsers extends StatelessWidget {
  const GetAllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final url = '/users/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      requestParams: () => {
        'page_size': '20',
        'page': '1',
      },
      getApiClient: (apiClient, params) async {
        await apiClient.get(
          url: url,
          params: params,
          addHeaders: authorizationBearerConnectTokenHeader,
        );
      },
    );
  }
}
