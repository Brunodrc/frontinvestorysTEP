import 'dart:convert';

class Transaction {
  final int id;
  final String stockCode;
  final int? investor;
  final int quantity_stock;
  final double unite_price;
  final String type_of;
  final double brokerage;
  final String date_done;
  final double total_operation;
  final double? average_price;
  final double? profit_loss;

  Transaction({
    required this.id,
    required this.stockCode,
    this.investor,
    required this.quantity_stock,
    required this.unite_price,
    required this.type_of,
    required this.brokerage,
    required this.date_done,
    required this.total_operation,
    this.average_price,
    this.profit_loss,
  });

  Transaction copyWith({
    int? id,
    String? stockCode,
    int? investor,
    int? quantity_stock,
    double? unite_price,
    String? type_of,
    double? brokerage,
    String? date_done,
    double? total_operation,
    double? average_price,
    double? profit_loss,
  }) {
    return Transaction(
      id: id ?? this.id,
      stockCode: stockCode ?? this.stockCode,
      investor: investor ?? this.investor,
      quantity_stock: quantity_stock ?? this.quantity_stock,
      unite_price: unite_price ?? this.unite_price,
      type_of: type_of ?? this.type_of,
      brokerage: brokerage ?? this.brokerage,
      date_done: date_done ?? this.date_done,
      total_operation: total_operation ?? this.total_operation,
      average_price: average_price ?? this.average_price,
      profit_loss: profit_loss ?? this.profit_loss,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stockCode': stockCode,
      'investor': investor,
      'quantity_stock': quantity_stock,
      'unite_price': unite_price,
      'type_of': type_of,
      'brokerage': brokerage,
      'date_done': date_done,
      'total_operation': total_operation,
      'average_price': average_price,
      'profit_loss': profit_loss,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    String stockCode =
        map.containsKey('stock') ? map['stock'] : map['stock_code'];

    return Transaction(
      id: map['id'],
      stockCode: stockCode,
      investor: map['investor'],
      quantity_stock: map['quantity_stock'],
      unite_price: double.parse(map['unite_price']),
      type_of: map['type_of'],
      brokerage: double.parse(map['brokerage']),
      date_done: map['date_done'],
      total_operation: double.parse(map['total_operation']),
      average_price: map['average_price'] != null
          ? double.parse(map['average_price'])
          : 0.0,
      profit_loss:
          map['profit_loss'] != null ? double.parse(map['profit_loss']) : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, stockCode: $stockCode, investor: $investor, quantity_stock: $quantity_stock, unite_price: $unite_price, type_of: $type_of, brokerage: $brokerage, date_done: $date_done, total_operation: $total_operation, average_price: $average_price, profit_loss: $profit_loss)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.stockCode == stockCode &&
        other.investor == investor &&
        other.quantity_stock == quantity_stock &&
        other.unite_price == unite_price &&
        other.type_of == type_of &&
        other.brokerage == brokerage &&
        other.date_done == date_done &&
        other.total_operation == total_operation &&
        other.average_price == average_price &&
        other.profit_loss == profit_loss;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        stockCode.hashCode ^
        investor.hashCode ^
        quantity_stock.hashCode ^
        unite_price.hashCode ^
        type_of.hashCode ^
        brokerage.hashCode ^
        date_done.hashCode ^
        total_operation.hashCode ^
        average_price.hashCode ^
        profit_loss.hashCode;
  }
}
