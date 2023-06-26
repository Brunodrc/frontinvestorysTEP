import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String riskProfile;
  final String acessToken;
  final String refreshToken;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.riskProfile,
    required this.acessToken,
    required this.refreshToken,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? riskProfile,
    String? acessToken,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      riskProfile: riskProfile ?? this.riskProfile,
      acessToken: acessToken ?? this.acessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'riskProfile': riskProfile,
      'acessToken': acessToken,
      'refreshToken': refreshToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      riskProfile: map['riskProfile'] as String,
      acessToken: map['acessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, riskProfile: $riskProfile, acessToken: $acessToken, refreshToken, $refreshToken)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.riskProfile == riskProfile &&
        other.acessToken == acessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        riskProfile.hashCode ^
        acessToken.hashCode ^
        refreshToken.hashCode;
  }
}
