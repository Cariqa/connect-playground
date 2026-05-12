import 'dart:convert';

import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class AddBillingDetails extends StatefulWidget {
  const AddBillingDetails({super.key});

  @override
  State<AddBillingDetails> createState() => _AddBillingDetailsState();
}

class _AddBillingDetailsState extends State<AddBillingDetails> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/billing-details/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.put,
      reqType: ReqType.body,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        "country": "DE",
        "line1": "Berliner Str. 123",
        "postal_code": "10119",
        "city": "Berlin",
        "account_type": "personal",
        "company_name": "",
        "vat_id": "",
        "tax_id": "",
        "first_name": "Max",
        "last_name": "Mustermann",
      },
      getApiClient: (apiClient, params) async {
        await apiClient.put(
          url: url,
          body: jsonEncode(params),
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
