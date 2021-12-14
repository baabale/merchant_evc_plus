## Hormuud Merchant EvcPlus API

NB. In order to have MERCHANT API credentials, you need to contact Hormuud Telecom.

## Usage

```dart
final merchantEvcPlus = MerchantEvcPlus(
    apiKey: '', // API KEY
    merchantUid: '', // Merchant UID
    apiUserId: '', // API USER ID
);

final transactionInfo = TransactionInfo(payerPhoneNumber: 'xxxxxx', amount: 1);

await merchantEvcPlus.makePayment(
    transactionInfo: transactionInfo,
    onSuccess: () {
        print('Payment Successful');
    },
    onFailure: (error) {
        print(error);
    },
);
```

**Show some ❤️ and star the repo to support the project**
