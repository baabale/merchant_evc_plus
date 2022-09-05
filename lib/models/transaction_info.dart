class TransactionInfo {
  final String payerPhoneNumber, referenceId, invoiceId, currency, description;
  final num amount;

  TransactionInfo({
    required this.payerPhoneNumber,
    required this.amount,
    this.referenceId = '',
    required this.invoiceId,
    this.currency = 'USD',
    this.description = 'Payment went through.',
  });
}
