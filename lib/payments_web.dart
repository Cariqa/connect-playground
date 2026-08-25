import 'package:connect_reference_client/_playground/reusable_widgets.dart';
import 'package:connect_reference_client/_playground/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';

// Client-side payment method addition (Flutter equivalent of the native Web library)
// https://docs.cariqa.com/payments-frontend-setup#-web-cards-+-google-pay
void addPaymentMethodWeb(BuildContext context, String setupIntentClientSecret) {
  showDialog(
    context: context,
    builder: (_) => UiPanel(
      children: [
        PaymentElement(
          wallets: const PaymentElementWalletOptions(
            googlePay: PaymentElementFieldRequired.auto,
            applePay: PaymentElementFieldRequired.auto,
          ),
          business: const PaymentElementBusiness(name: 'Cariqa Connect Playground'),
          layout: PaymentElementLayout.tabs,
          clientSecret: setupIntentClientSecret,
          onCardChanged: (details) {},
        ),
        FilledButton(
          child: Text('Add card'),
          onPressed: () async {
            await WebStripe.instance.confirmSetupElement(
              ConfirmSetupElementOptions(
                confirmParams: ConfirmSetupParams(return_url: Uri.base.replace(path: '/payment-redirect').toString()),
                redirect: SetupConfirmationRedirect.ifRequired,
              ),
            );

            showSnackbar(context, 'Payment method added');
            Navigator.maybePop(context);
          },
        )
      ],
    ),
  );
}

// Client-side payment confirmation (Flutter equivalent of the native Web library)
// https://docs.cariqa.com/patterns-payments-outstanding#client-side-payment-confirmation
Future<void> confirmPaymentWeb({required String paymentIntentClientSecret, required String paymentMethodId}) async {
  await WebStripe.instance.confirmPayment(
    paymentIntentClientSecret,
    PaymentMethodParams.cardFromMethodId(
      paymentMethodData: PaymentMethodDataCardFromMethod(
        paymentMethodId: paymentMethodId,
      ),
    ),
  );
}
