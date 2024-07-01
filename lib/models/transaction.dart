class Transaction {
  String title;
  int amount;
  DateTime dateTime;
  TransactionType type;

  Transaction(
      {required this.title,
      required this.amount,
      required this.dateTime,
      required this.type});

  static List<Transaction> getList() {
    return [
      Transaction(
          title: "Modou FALL",
          amount: 10000,
          dateTime: DateTime(2024, 5, 24),
          type: TransactionType.transfertS),
      Transaction(
          title: "Assaira Diop",
          amount: 10000,
          dateTime: DateTime(2024, 5, 24),
          type: TransactionType.transfertE),
      Transaction(
          title: "Retrait",
          amount: 30000,
          dateTime: DateTime(2024, 5, 27),
          type: TransactionType.retrait),
      Transaction(
          title: "Paiement Canal+",
          amount: 15000,
          dateTime: DateTime(2024, 5, 31),
          type: TransactionType.paiement),
      Transaction(
          title: "Credit Orange",
          amount: 15000,
          dateTime: DateTime(2024, 6, 1),
          type: TransactionType.credit),
      Transaction(
          title: "Depot",
          amount: 55000,
          dateTime: DateTime(2024, 6, 2),
          type: TransactionType.depot),
    ];
  }
}

enum TransactionType { transfertS,transfertE, retrait, paiement, credit, depot }
