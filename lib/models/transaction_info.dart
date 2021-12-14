class TransactionInfo {
  final String payerPhoneNumber, referenceId, invoiceId, currency, description;
  final double amount;

  TransactionInfo({
    required this.payerPhoneNumber,
    required this.amount,
    this.referenceId = '',
    this.invoiceId = '',
    this.currency = 'USD',
    this.description = 'Payment went through.',
  });
}
