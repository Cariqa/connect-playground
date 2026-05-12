<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/readme/header_dark.png">
    <source media="(prefers-color-scheme: light)" srcset="assets/readme/header_light.png">
    <img alt="Banner" src="assets/readme/header_light.png" width="100%">
  </picture>
</p>

# Connect API Playground

Playground for the [Cariqa Connect API](https://docs.cariqa.com) that enables OEMs, mobility services and platforms to seamlessly offer EV charging through a single API integration, unlocking direct charge point operator prices for their end users while removing operational complexity and ensuring full regulatory compliance.

Demonstrates how to authenticate, call endpoints + Stripe integration, written in Flutter (iOS, Android, web).

Not using Flutter? The integration **flow** is the same on every platform — only the Stripe SDK calls differ. Use this as a reference for the flow, then swap in the [Stripe SDK for your platform](https://docs.cariqa.com/payments-frontend-setup).


**Live playground:** [play.connect.cariqa.com](https://play.connect.cariqa.com)
 
---

## What's inside this repo

**Core**
- [`lib/main.dart`](lib/main.dart) — app entry point
- [`lib/modules/`](lib/modules/) — minimal usage example per Connect API endpoint
- [`lib/payments_initialization.dart`](lib/payments_initialization.dart) — Stripe SDK initialization
- [`lib/payments_mobile.dart`](lib/payments_mobile.dart) — Stripe SDK integration for Android and iOS
- [`lib/payments_web.dart`](lib/payments_web.dart) — Stripe SDK integration for Web

**Platform config**
- [`ios/`](ios/) — basic iOS config with Stripe/Google Maps; no business logic
- [`android/`](android/) — basic Android config with Stripe/Google Maps; no business logic
- [`web/`](web/) — basic Web config; no business logic

**Demo only**
- [`lib/_playground/`](lib/_playground/) — UI wrapper for the hosted site; safe to ignore


## API keys
You'll need API keys — get them from the onboarding team.
Then either:
- Put them into a `.env` file in the project root
- Or skip it and enter them directly in the playground
  (in test mode they're saved even after restart)

### Google Maps API Key

**iOS:** Add to `ios/Secrets.xcconfig`.

**Android:** Add to `android/secrets.properties`.

## Quickstart (Flutter web)

Install Flutter: https://docs.flutter.dev/install
- Flutter 3.41.4 (latest tested version)

Clone app:
```bash
git clone https://github.com/
cd project
flutter pub get
flutter run -d chrome --dart-define-from-file=.env    # or -d ios / -d android
```


