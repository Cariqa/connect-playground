import 'package:flutter_stripe/flutter_stripe.dart';

void applyStripeSettings({required String stripePublishableKey}) {
  Stripe.publishableKey = stripePublishableKey;
  Stripe.urlScheme = 'dev.cariqa.reference.client.cariqa.com';
  Stripe.merchantIdentifier = 'merchant.connect.cariqa.com';
  Stripe.instance.applySettings();
}
