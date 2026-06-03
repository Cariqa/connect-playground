import 'package:flutter_stripe/flutter_stripe.dart';

void applyStripeSettings({required String stripePublishableKey}) {
  Stripe.publishableKey = stripePublishableKey;

  // iOS url scheme: https://github.com/Cariqa/connect-playground/blob/main/ios/Runner/Info.plist
  // Android url scheme: https://github.com/Cariqa/connect-playground/blob/main/android/app/src/main/AndroidManifest.xml
  Stripe.urlScheme = 'dev.cariqa.reference.client.cariqa.com';

  // Apple Pay merchant identifier
  // https://github.com/Cariqa/connect-playground/blob/main/ios/Runner/Runner.entitlements
  Stripe.merchantIdentifier = 'merchant.connect.cariqa.com';

  Stripe.instance.applySettings();
}
