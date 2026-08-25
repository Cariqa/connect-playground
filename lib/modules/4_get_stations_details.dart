import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetStationDetails extends StatelessWidget {
  const GetStationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final url = '/stations/details/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      requestParams: () => {
        'id': '',
        'type': 'station_id',
      },
      getApiClient: (apiClient, requestParams) async {
        final res = await apiClient.get(
          url: url,
          params: requestParams,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        evseId = res['evses']?[0]?['evse_id'];
      },
    );
  }
}
