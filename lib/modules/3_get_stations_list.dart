import 'dart:math';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetStationsList extends StatelessWidget {
  const GetStationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final url = '/stations/around/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      requestParams: () => {
        'latitude': '52.51',
        'longitude': '13.45',
        'distance': '10000',
        'page_size': '20',
        'page': '1',
        'max_price': '',
        'only_available': 'false',
        'only_partners': 'false',
        'connector_types': [],
        'operators': [],
        'power_groups': [],
      },
      getApiClient: (apiClient, queryParams) async {
        final response = await apiClient.get(
          url: url,
          params: queryParams,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        final randomIndex = Random().nextInt(response['results'].length);
        stationId = response['results'][randomIndex]?['id'];
      },
    );
  }
}
