import 'package:connect_reference_client/_playground/models.dart';
import 'package:connect_reference_client/_playground/playground.dart';
import 'package:connect_reference_client/_playground/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> addIosPaymentMethod(BuildContext context, String setupIntentClientSecret) async {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      setupIntentClientSecret: setupIntentClientSecret,
      merchantDisplayName: '[Cariqa Connect Playground]',
      applePay: PaymentSheetApplePay(
        merchantCountryCode: 'DE',
        cartItems: [
          ApplePayCartSummaryItem.immediate(
            amount: '0.00',
            isPending: true,
            label: 'Authorisation for Cariqa Connect Playground',
          )
        ],
      ),
      billingDetailsCollectionConfiguration: const BillingDetailsCollectionConfiguration(
        address: AddressCollectionMode.never,
      ),
    ),
  );

  await Stripe.instance.presentPaymentSheet(options: const PaymentSheetPresentOptions());
  await Stripe.instance.resetPaymentSheetCustomer();

  showSnackbar(context, 'Payment method added');
}

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

// On mobile we use respective methods from above.
Future<void> addPaymentMethod(BuildContext context, String setupIntentClientSecret) async {}
