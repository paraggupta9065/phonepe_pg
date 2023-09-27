## Flutter PhonePe PG Package

This package provides a Flutter wrapper for the PhonePe PG SDK, allowing you to easily accept payments from your Flutter Web app.

**Usage**

To use the package, first add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  phonepe_pg: ^1.0.0

import 'package:phonepe_pg/phonepe_pg.dart';


To initialize a transaction, call the `initTransaction()` method with the following parameters:

* `merchantTransactionId`: An optional identifier for the transaction.
* `customerMobile`: The customer's mobile number.
* `amount`: The amount to be paid.
* `redirectType`: The redirect type to use.

The `redirectType` parameter can be set to either `RedirectType.REDIRECT` or `RedirectType.POST`. If `RedirectType.REDIRECT` is specified, the user will be redirected to the PhonePe app to complete the payment. If `RedirectType.POST` is specified, the payment will be completed within your Flutter app.

The `initTransaction()` method returns a `PaymentResponse` object, which contains the status of the transaction and the redirect URL (if `RedirectType.REDIRECT` was specified).

**Example**

The following example shows how to initialize a transaction with the PhonePe PG SDK:

dart
import 'package:phonepe_pg/phonepe_pg.dart';

Future<PaymentResponse> initTransaction() async {
  PaymentResponse paymentResponse = await PhonePePg.initTransaction({
    'customerMobile': '+919876543210',
    'amount': 100,//amount should be in paise 100=1 rupee
    'redirectType': RedirectType.REDIRECT,
  });

  return paymentResponse;
}


To start the transaction, call the `launchUrl()` method with the redirect URL returned by the `initTransaction()` method.

**Debug mode**

In debug mode, the package will use the PhonePe sandbox environment. To enable debug mode, set the `debug` property to `true` when initializing the `PhonePePg` object.

dart
PhonePePg phonePePg = PhonePePg(
  merchantId: 'YOUR_MERCHANT_ID',
  merchantUserId: 'YOUR_MERCHANT_USER_ID',
  salt: 'YOUR_SALT',
  saltIndex: 'YOUR_SALT_INDEX',
  redirectUrl: 'YOUR_REDIRECT_URL',
  callbackUrl: 'YOUR_CALLBACK_URL',
  debug: true,
);


**Feedback**

If you have any feedback or suggestions, please feel free to create an issue on the GitHub repository.


You can also add more information to the README file, such as:

* A description of the package and its features.
* Instructions on how to install and use the package.
* Examples of how to use the package.
* A list of dependencies.
* A link to the GitHub repository.

Once you have created the README file, you can push it to your GitHub repository.
