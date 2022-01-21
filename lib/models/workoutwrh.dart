import 'dart:convert';

import 'package:getfitappmobile/models/user_model.dart';

class Wokoutwrh {
  int? WorkOutWrhId;
  int? UserId;
  String? ActivityName;
  UserModel? User;
  DateTime? Data;
  DateTime? Start;
  DateTime? End;
  int? Ripetizioni;
  double? Km;
  Wokoutwrh({
    this.WorkOutWrhId,
    this.UserId,
    this.ActivityName,
    this.User,
    this.Data,
    this.Start,
    this.End,
    this.Ripetizioni,
    this.Km,
  });

  Map<String, dynamic> toMap() {
    return {
      'WorkOutWrhId': WorkOutWrhId,
      'UserId': UserId,
      'ActivityName': ActivityName,
      'User': User?.toMap(),
      'Data': Data?.toIso8601String(),
      'Start': Start?.toIso8601String(),
      'End': End?.toIso8601String(),
      'Ripetizioni': Ripetizioni,
      'Km': Km,
    };
  }

  factory Wokoutwrh.fromMap(Map<String, dynamic> map) {
    return Wokoutwrh(
      WorkOutWrhId: map['workOutWrhId']?.toInt(),
      UserId: map['userId']?.toInt(),
      ActivityName: map['activityName'],
      User: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      Data: map['data'] != null ? DateTime.tryParse(map['data']) : null,
      Start: map['start'] != null ? DateTime.tryParse(map['start']) : null,
      End: map['end'] != null ? DateTime.tryParse(map['end']) : null,
      Ripetizioni: map['ripetizioni']?.toInt(),
      Km: map['km']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Wokoutwrh.fromJson(String source) =>
      Wokoutwrh.fromMap(json.decode(source));
}

class Training {
  num? Min_Gg;
  num? Min_M;
  num? Km_Gg;
  num? Km_M;
  num? Km_Tot;
  Training({
    this.Min_Gg,
    this.Min_M,
    this.Km_Gg,
    this.Km_M,
    this.Km_Tot,
  });

  Map<String, dynamic> toMap() {
    return {
      'Min_Gg': Min_Gg,
      'Min_M': Min_M,
      'Km_Gg': Km_Gg,
      'Km_M': Km_M,
      'Km_Tot': Km_Tot,
    };
  }

  factory Training.fromMap(Map<String, dynamic> map) {
    return Training(
      Min_Gg: map['min_Gg'],
      Min_M: map['min_M'],
      Km_Gg: map['km_Gg'],
      Km_M: map['km_M'],
      Km_Tot: map['km_Tot'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Training.fromJson(String source) =>
      Training.fromMap(json.decode(source));
}
