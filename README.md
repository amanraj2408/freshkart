# FreshKart

FreshKart is a Flutter grocery shopping demo for browsing everyday produce, building a basket, applying sample coupons, and walking through a simulated checkout.

The interface pairs a forest-green and citrus palette with warm paper surfaces, editorial product cards, and a market-style home feed. The app is built with Material 3 and Provider.

> This repository is a UI and interaction demo. Product data, sign-in, checkout, delivery timing, and order tracking are simulated locally; there is no production backend or payment processing.

## Features

- Browse grocery categories and search the sample catalog.
- View product details, mark favorites, and adjust basket quantities.
- See calculated totals, delivery fees, and sample coupon discounts.
- Walk through address and payment selection in the demo checkout.
- View simulated order status and order history.
- Continue as a guest or explore the sample authentication screens.

## Run locally

### Requirements

- Flutter SDK with Dart 3.0 or later.
- Android Studio and an Android SDK for Android builds.
- An Android emulator or connected device for mobile runs.

### Android

```sh
flutter doctor
flutter pub get
flutter devices
flutter run -d <android-device-id>
```

To build a debug APK:

```sh
flutter build apk --debug
```

The APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.

## Tests

Run the Flutter tests with:

```sh
flutter test
```

Run static analysis with:

```sh
flutter analyze
```

## Project layout

```text
lib/
  constants/     Theme colors, styles, and app configuration
  models/        Product, category, basket, order, and profile models
  providers/     Provider-based app state
  screens/       Authentication, catalog, basket, checkout, and profile UI
  services/      Sample catalog and promotional content
  widgets/       Reusable catalog and form components
test/            Widget smoke test and basket provider tests
android/         Android application and Gradle configuration
assets/          App image and icon assets
```

## Sample coupons

- `FRESH50` - ₹50 off
- `WELCOME100` - ₹100 off
- `ORGANIC20` - ₹20 off

Prices use the Indian rupee. Coupon behavior and delivery thresholds are demo logic.

## Acknowledgments

The initial quick-commerce concept was inspired by [Blinkit-UI](https://github.com/sujal880/Blinkit-UI). FreshKart uses its own branding and Flutter implementation.

## License

No `LICENSE` file is currently included. Add one before redistributing this project under a specific open-source license.
"# freshkart" 
