import 'package:connect_reference_client/_playground/reusable_widgets.dart';
import 'package:connect_reference_client/_playground/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';

void addPaymentMethod(BuildContext context, String setupIntentClientSecret) {
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

Future<void> confirmPayment({required String paymentIntentClientSecret, required String paymentMethodId}) async {
  await Stripe.instance.confirmPayment(
    paymentIntentClientSecret: paymentIntentClientSecret,
    data: PaymentMethodParams.cardFromMethodId(
      paymentMethodData: PaymentMethodDataCardFromMethod(
        paymentMethodId: paymentMethodId,
      ),
    ),
  );
}

// On web there is no separation between iOS and Android, so we just use [addPaymentMethod()] from above.
Future<void> addIosPaymentMethod(BuildContext context, String setupIntentClientSecret) async {}
Future<void> addAndroidPaymentMethod(BuildContext context, String setupIntentClientSecret) async {}
