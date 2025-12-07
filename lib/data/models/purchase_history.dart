class PurchaseHistory {
  final List<String> items;
  final int total;
  final DateTime date;

  PurchaseHistory({
    required this.items,
    required this.total,
    required this.date,
  });

  factory PurchaseHistory.fromMap(Map<String, dynamic> map) {
    return PurchaseHistory(
      items: List<String>.from(map['items']),
      total: map['total'],
      date: map['date'].toDate(),
    );
  }
}
