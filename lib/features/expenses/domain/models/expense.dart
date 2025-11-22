class Expense {
  final String id;
  final String title;
  final double amount;

  Expense({required this.id, required this.title, required this.amount});

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'amount': amount};
}
