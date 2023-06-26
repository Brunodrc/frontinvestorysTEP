import 'dart:convert';

class Stock {
  final int id;
  final String code;
  final String nameEnterprise;
  final String cnpj;

  Stock({
    required this.id,
    required this.code,
    required this.nameEnterprise,
    required this.cnpj,
  });

  Stock copyWith({
    int? id,
    String? code,
    String? nameEnterprise,
    String? cnpj,
  }) {
    return Stock(
      id: id ?? this.id,
      code: code ?? this.code,
      nameEnterprise: nameEnterprise ?? this.nameEnterprise,
      cnpj: cnpj ?? this.cnpj,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'nameEnterprise': nameEnterprise,
      'cnpj': cnpj,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      code: map['code'] as String,
      nameEnterprise: map['name_enterprise'] as String,
      cnpj: map['cnpj'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) =>
      Stock.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Stock(id: $id, code: $code, nameEnterprise: $nameEnterprise, cnpj: $cnpj, )';
  }

  @override
  bool operator ==(covariant Stock other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.nameEnterprise == nameEnterprise &&
        other.cnpj == cnpj;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        nameEnterprise.hashCode ^
        cnpj.hashCode;
  }
}
