class CarWash {
  final int date;
  final int amount;
  final String memo;

  CarWash({this.date, this.amount, this.memo});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
      'memo': memo,
    };
  }

  @override
  String toString() {
    return 'CarWash{date: $date, amount: $amount, memo: $memo}';
  }
}
