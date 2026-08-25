import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetPartnersList extends StatelessWidget {
  const GetPartnersList({super.key});

  @override
  Widget build(BuildContext context) {
    final url = '/stations/partners/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      requestParams: () => {},
      getApiClient: (apiClient, requestParams) async {
        await apiClient.get(
          url: url,
          addHeaders: authorizationBearerConnectTokenHeader,
        );
      },
    );
  }
}
