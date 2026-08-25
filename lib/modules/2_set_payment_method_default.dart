import 'dart:convert';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class SetPaymentMethodDefault extends StatefulWidget {
  const SetPaymentMethodDefault({super.key});

  @override
  State<SetPaymentMethodDefault> createState() => _SetPaymentMethodDefaultState();
}

class _SetPaymentMethodDefaultState extends State<SetPaymentMethodDefault> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/payment-methods/$paymentMethodId/default/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.post,
      reqType: ReqType.body,
      pathParams: () => {
        'userId': '',
        'paymentMethodId': '',
      },
      requestParams: () => {},
      getApiClient: (apiClient, requestParams) async {
        await apiClient.post(
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

    final newPathPaymentMethodId = pathParams['paymentMethodId'] ?? '';
    if (newPathPaymentMethodId != '') paymentMethodId = newPathPaymentMethodId;
    setState(() {});
  }
}
