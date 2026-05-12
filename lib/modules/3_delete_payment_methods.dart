import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class DeletePaymentMethod extends StatefulWidget {
  const DeletePaymentMethod({super.key});

  @override
  State<DeletePaymentMethod> createState() => _DeletePaymentMethodState();
}

class _DeletePaymentMethodState extends State<DeletePaymentMethod> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/payment-methods/$paymentMethodId';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.delete,
      pathParams: () => {
        'userId': '',
        'paymentMethodId': '',
      },
      requestParams: () => {},
      getApiClient: (apiClient, params) async {
        final res = await apiClient.delete(
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
