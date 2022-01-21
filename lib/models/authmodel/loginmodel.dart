// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Loginmodel {
  String Username;
  String Password;

  Loginmodel({required this.Username, required this.Password});

  Map<String, dynamic> toMap() {
    return {
      'Username': Username,
      'Password': Password,
    };
  }

  factory Loginmodel.fromMap(Map<String, dynamic> map) {
    return Loginmodel(
      Username: map['Username'],
      Password: map['Password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Loginmodel.fromJson(String source) =>
      Loginmodel.fromMap(json.decode(source));
}
