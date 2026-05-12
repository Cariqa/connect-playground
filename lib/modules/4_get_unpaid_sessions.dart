import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/module_widget.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class GetUnpaidSessions extends StatefulWidget {
  const GetUnpaidSessions({super.key});

  @override
  State<GetUnpaidSessions> createState() => _GetUnpaidSessionsState();
}

class _GetUnpaidSessionsState extends State<GetUnpaidSessions> {
  @override
  Widget build(BuildContext context) {
    final url = '/users/$userId/charging/debts/';
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
          addHeaders: authorizationBearerConnectTokenHeader,
        );

        final debts = res['results'] as List<dynamic>;
        if (debts.isNotEmpty) {
          final firstDebtPaymentIntent = debts[0]['client_secret'];
          await Stripe.instance.confirmPayment(
            paymentIntentClientSecret: firstDebtPaymentIntent,
            data: PaymentMethodParams.cardFromMethodId(
              paymentMethodData: PaymentMethodDataCardFromMethod(
                paymentMethodId: paymentMethodId!,
              ),
            ),
          );
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
