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
  PaymentResponse paymentResponse = await PhonePePaymentSdk.initTransaction({
    'customerMobile': '+919876543210',
    'amount': 100.00,
    'redirectType': RedirectType.REDIRECT,
  });

  return paymentResponse;
}


To start the transaction, call the `launchUrl()` method with the redirect URL returned by the `initTransaction()` method.

**Debug mode**

In debug mode, the package will use the PhonePe sandbox environment. To enable debug mode, set the `debug` parameter to `true` when calling the `initTransaction()` method.

**Feedback**

If you have any feedback or suggestions, please feel free to create an issue on the GitHub repository.

**Function description**

The `initTransaction()` function initializes a transaction with the PhonePe PG SDK. It takes the following parameters:

* `merchantTransactionId`: An optional identifier for the transaction.
* `customerMobile`: The customer's mobile number.
* `amount`: The amount to be paid.
* `redirectType`: The redirect type to use.

The `initTransaction()` function returns a `PaymentResponse` object, which contains the status of the transaction and the redirect URL (if `RedirectType.REDIRECT` was specified).

**Example usage**

The following example shows how to use the `initTransaction()` function to initialize a transaction and launch the PhonePe app to complete the payment:

dart
import 'package:phonepe_pg/phonepe_pg.dart';

Future<void> main() async {
  // Initialize the transaction.
  PaymentResponse paymentResponse = await initTransaction();

  // Launch the PhonePe app to complete the payment.
  await launchUrl(Uri.parse(paymentResponse.data.instrumentResponse.redirectInfo.url));
}


**Conclusion**

The `initTransaction()` function is a convenient way to initialize a transaction with the PhonePe PG SDK. It is easy to use and provides all of the necessary parameters to complete a payment.
