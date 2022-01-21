import 'dart:convert';

class Registermodel {
  String? name;
  String? lastName;
  DateTime? birthday;
  String? username;
  String? password;
  String? confermaPassword;
  String? email;
  String? height;
  String? weight;
  String? gender;
  String? region;

  Registermodel(
      {this.name,
      this.lastName,
      this.birthday,
      this.username,
      this.password,
      this.confermaPassword,
      this.email,
      this.height,
      this.weight,
      this.gender,
      this.region});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
      'username': username,
      'Password': password,
      'ConfermaPassword': confermaPassword,
      'Email': email,
      'height': height,
      'Weight': weight,
      'Gender': gender,
      'Region': region
    };
  }

  factory Registermodel.fromMap(Map<String, dynamic> map) {
    return Registermodel(
        name: map['Name'],
        lastName: map['LastName'],
        birthday: map['Birthday'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['Birthday'])
            : null,
        username: map['Username'],
        password: map['Password'],
        height: map['height'],
        weight: map['Weight'],
        confermaPassword: map['ConfermaPassword'],
        email: map['Email'],
        gender: map['Gender'],
        region: map['Region']);
  }

  String toJson() => json.encode(toMap());

  factory Registermodel.fromJson(String source) =>
      Registermodel.fromMap(json.decode(source));
}
