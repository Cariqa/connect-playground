import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:connect_reference_client/payments_android.dart';
import 'package:connect_reference_client/payments_ios.dart';
import 'package:connect_reference_client/payments_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/setup-intents/';

    return ModuleWidget(
      urlName: url,
      apiType: ApiType.get,
      pathParams: () => {
        'userId': '',
      },
      requestParams: () => {
        'pm_type': 'card',
      },
      getApiClient: (apiClient, requestParams) async {
        final res = await apiClient.get(
          url: url,
          params: requestParams,
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        // Web:
        if (kIsWeb) {
          addPaymentMethodWeb(context, res['setup_intent_client_secret']);
        }

        // iOS:
        if (isMobileIos) {
          addIosPaymentMethod(context, res['setup_intent_client_secret']);
        }

        // Android
        if (isMobileAndroid) {
          addAndroidPaymentMethod(context, res['setup_intent_client_secret']);
        }
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
