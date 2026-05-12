import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';

class GetInvoices extends StatefulWidget {
  const GetInvoices({super.key});

  @override
  State<GetInvoices> createState() => _GetInvoicesState();
}

class _GetInvoicesState extends State<GetInvoices> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/invoices/';
    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        "page_size": "10",
        "page": "1",
      },
      getApiClient: (apiClient, params) async {
        await apiClient.get(
          url: url,
          params: params,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        setState(() {});
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
