import 'package:connect_reference_client/_playground/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// Client-side payment method addition (Flutter equivalent of the native iOS SDK method)
// https://docs.cariqa.com/payments-frontend-setup#-mobile-ios-cards-+-apple-pay
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

// Client-side payment confirmation (Flutter equivalent of the native iOS SDK method)
// https://docs.cariqa.com/patterns-payments-outstanding#client-side-payment-confirmation
Future<void> confirmPaymentIos({required String paymentIntentClientSecret, required String paymentMethodId}) async {
  await Stripe.instance.confirmPayment(
    paymentIntentClientSecret: paymentIntentClientSecret,
    data: PaymentMethodParams.cardFromMethodId(
      paymentMethodData: PaymentMethodDataCardFromMethod(
        paymentMethodId: paymentMethodId,
      ),
    ),
  );
}
