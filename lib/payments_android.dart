import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:connect_reference_client/_playground/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// Client-side payment method addition (Flutter equivalent of the native Android SDK method)
// https://docs.cariqa.com/payments-frontend-setup#-mobile-android-cards-+-google-pay
Future<void> addAndroidPaymentMethod(BuildContext context, String setupIntentClientSecret) async {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      setupIntentClientSecret: setupIntentClientSecret,
      merchantDisplayName: '[Cariqa Connect Playground]',
      googlePay: PaymentSheetGooglePay(
        currencyCode: 'EUR',
        label: 'Authorisation for Cariqa Connect Playground',
        merchantCountryCode: 'DE',
        amount: '0.00',
        testEnv: runMode == RunMode.dev,
      ),
      billingDetailsCollectionConfiguration:
          const BillingDetailsCollectionConfiguration(address: AddressCollectionMode.never),
    ),
  );

  await Stripe.instance.presentPaymentSheet(options: const PaymentSheetPresentOptions());
  await Stripe.instance.resetPaymentSheetCustomer();

  showSnackbar(context, 'Payment method added');
}

// Client-side payment confirmation (Flutter equivalent of the native Android SDK method)
// https://docs.cariqa.com/patterns-payments-outstanding#client-side-payment-confirmation
Future<void> confirmPaymentAndroid({required String paymentIntentClientSecret, required String paymentMethodId}) async {
  await Stripe.instance.confirmPayment(
    paymentIntentClientSecret: paymentIntentClientSecret,
    data: PaymentMethodParams.cardFromMethodId(
      paymentMethodData: PaymentMethodDataCardFromMethod(
        paymentMethodId: paymentMethodId,
      ),
    ),
  );
}
