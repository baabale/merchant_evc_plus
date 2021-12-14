library merchant_evc_plus;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:merchant_evc_plus/models/transaction_info.dart';

export './models/transaction_info.dart';

class MerchantEvcPlus {
  final String endPoint;
  final String merchantUid;
  final String apiUserId;
  final String apiKey;

  const MerchantEvcPlus({
    this.endPoint = 'https://api.waafi.com/asm',
    required this.merchantUid,
    required this.apiUserId,
    required this.apiKey,
  });

  Future<void> makePayment({
    required TransactionInfo transactionInfo,
    Function()? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(endPoint),
        body: json.encode(
          {
            "schemaVersion": "1.0",
            "requestId": "101111003",
            "timestamp": "client_timestamp",
            "channelName": "WEB",
            "serviceName": "API_PURCHASE",
            "serviceParams": {
              "merchantUid": merchantUid,
              "apiUserId": apiUserId,
              "apiKey": apiKey,
              "paymentMethod": "mwallet_account",
              "payerInfo": {"accountNo": transactionInfo.payerPhoneNumber},
              "transactionInfo": {
                "referenceId": transactionInfo.referenceId,
                "invoiceId": transactionInfo.invoiceId,
                "amount": transactionInfo.amount.toString(),
                "currency": transactionInfo.currency,
                "description": transactionInfo.description
              }
            }
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["responseMsg"] == 'RCS_SUCCESS') {
          onSuccess!();
        }
        String message = '';
        var errMessage = data['responseMsg'].toString().split(':');
        if (errMessage[2] == ' User Aborted)') {
          message = 'User Cancelled';
        } else if (errMessage[2] == ' Subscriber Not Found)') {
          message = 'Wrong Telephone Number';
        } else if (errMessage[2] == ' Invalid PIN)') {
          message = 'Invalid PIN';
        } else if (errMessage[2] ==
            ' Customer rejected to authorize payment)') {
          message = 'User Rejected';
        } else if (errMessage[2] == ' Dialog Timedout)') {
          message = 'Dialog Timedout';
        } else if (errMessage[2].contains('Timeout')) {
          message = 'User Timeout';
        } else {
          message = response.body.toString();
        }
        onFailure!(message);
      } else {
        onFailure!(response.body);
      }
    } on SocketException {
      onFailure!('No Internet Connection');
    } catch (e) {
      onFailure!(e.toString());
    }
  }
}
