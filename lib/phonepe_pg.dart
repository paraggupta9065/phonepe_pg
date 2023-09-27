// ignore_for_file: public_member_api_docs, sort_constructors_first
library phonepe_pg;

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:phonepe_pg/model/payment_response.dart';

enum RedirectType { POST, REDIRECT }

class PhonePePg {
  String merchantId;
  String merchantUserId;
  String salt;
  String saltIndex;
  String redirectUrl;
  String callbackUrl;
  bool debug;

  PhonePePg({
    required this.merchantId,
    required this.merchantUserId,
    required this.salt,
    required this.saltIndex,
    required this.redirectUrl,
    required this.callbackUrl,
    this.debug = false,
  });

  Uuid uuid = const Uuid();

  initTransaction({
    String? merchantTransactionId,
    required String customerMobile,
    required double amount,
    required RedirectType redirectType,
  }) async {
    Map<String, dynamic> body = {
      "merchantId": merchantId,
      "merchantTransactionId": merchantTransactionId ?? uuid.v1(),
      "merchantUserId": merchantUserId,
      "amount": amount,
      "redirectUrl": redirectUrl,
      "redirectMode":
          redirectType == RedirectType.REDIRECT ? "REDIRECT" : "POST",
      "callbackUrl": callbackUrl,
      "mobileNumber": customerMobile,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64String = base64.encode(utf8.encode(jsonEncode(body)));
    String toEncodeToSha256 = '$base64String/pg/v1/pay$salt';
    final String sha256String =
        crypto.sha256.convert(utf8.encode(toEncodeToSha256)).toString();

    final String finalString = '$sha256String###$saltIndex';

    Uri url = Uri.parse(debug
        ? "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay"
        : "https://api.phonepe.com/apis/hermes/pg/v1/pay");

    http.Response response = await http
        .post(url, body: json.encode({"request": base64String}), headers: {
      "Content-Type": "application/json",
      "X-VERIFY": finalString,
      "Access-Control-Allow-Credentials": "true",
      'Access-Control-Allow-Origin': '*',
      "Access-Control-Allow-Methods": 'GET, DELETE, HEAD, OPTIONS',
      "Origin": 'api-preprod.phonepe.com',
    });

    print(response.body);

    PaymentResponse paymentResponse =
        PaymentResponse.fromJson(json.decode(response.body));

    await launchUrl(
        Uri.parse(paymentResponse.data.instrumentResponse.redirectInfo.url));

    return paymentResponse;
  }

  PhonePePg copyWith({
    String? merchantId,
    String? merchantUserId,
    String? salt,
    String? saltIndex,
    String? redirectUrl,
    String? callbackUrl,
    bool? debug,
  }) {
    return PhonePePg(
      merchantId: merchantId ?? this.merchantId,
      merchantUserId: merchantUserId ?? this.merchantUserId,
      salt: salt ?? this.salt,
      saltIndex: saltIndex ?? this.saltIndex,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      debug: debug ?? this.debug,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'merchantId': merchantId,
      'merchantUserId': merchantUserId,
      'salt': salt,
      'saltIndex': saltIndex,
      'redirectUrl': redirectUrl,
      'callbackUrl': callbackUrl,
      'debug': debug,
    };
  }

  factory PhonePePg.fromMap(Map<String, dynamic> map) {
    return PhonePePg(
      merchantId: map['merchantId'] as String,
      merchantUserId: map['merchantUserId'] as String,
      salt: map['salt'] as String,
      saltIndex: map['saltIndex'] as String,
      redirectUrl: map['redirectUrl'] as String,
      callbackUrl: map['callbackUrl'] as String,
      debug: map['debug'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhonePePg.fromJson(String source) =>
      PhonePePg.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhonePePg(merchantId: $merchantId, merchantUserId: $merchantUserId, salt: $salt, saltIndex: $saltIndex, redirectUrl: $redirectUrl, callbackUrl: $callbackUrl, debug: $debug)';
  }

  @override
  bool operator ==(covariant PhonePePg other) {
    if (identical(this, other)) return true;

    return other.merchantId == merchantId &&
        other.merchantUserId == merchantUserId &&
        other.salt == salt &&
        other.saltIndex == saltIndex &&
        other.redirectUrl == redirectUrl &&
        other.callbackUrl == callbackUrl &&
        other.debug == debug;
  }

  @override
  int get hashCode {
    return merchantId.hashCode ^
        merchantUserId.hashCode ^
        salt.hashCode ^
        saltIndex.hashCode ^
        redirectUrl.hashCode ^
        callbackUrl.hashCode ^
        debug.hashCode;
  }
}
