import 'dart:convert';

class UserModel {
  int? id;
  String? role;
  String? name;
  String? lastName;
  DateTime? birthday;
  String? username;
  String? email;
  num? height;
  num? weight;
  String? gender;
  String? region;
  String? photo;
  bool? isban;

  UserModel(
      {this.name,
      this.id,
      this.role,
      this.lastName,
      this.birthday,
      this.username,
      this.email,
      this.height,
      this.weight,
      this.gender,
      this.photo,
      this.isban,
      this.region});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
      'userName': username,
      'email': email,
      'height': height,
      'weight': weight,
      'gender': gender,
      'region': region,
      'photo': photo,
      'isBan': isban
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        role: map['role'],
        name: map['name'],
        lastName: map['lastName'],
        birthday:
            map['birthday'] != null ? DateTime.tryParse(map['birthday']) : null,
        username: map['userName'],
        height: map['height'],
        weight: map['weight'],
        email: map['email'],
        gender: map['gender'],
        region: map['region'],
        id: map['id'],
        isban: map['isBan'],
        photo: map['photo']);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
