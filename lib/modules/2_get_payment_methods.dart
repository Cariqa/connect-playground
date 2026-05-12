import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetPaymentMethods extends StatefulWidget {
  const GetPaymentMethods({super.key});

  @override
  State<GetPaymentMethods> createState() => _GetPaymentMethodsState();
}

class _GetPaymentMethodsState extends State<GetPaymentMethods> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/payment-methods/';
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
        final res = await apiClient.get(
          url: url,
          params: params,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        paymentMethodId = res['results']?[0]?['id'];
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
