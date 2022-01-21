// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Works {
  int? UserId;
  String? ActivityName;
  DateTime? Date;
  DateTime? Start;
  DateTime? End;
  int? Ripetizioni;
  double? Km;
  Works({
    this.UserId,
    this.ActivityName,
    this.Date,
    this.Start,
    this.End,
    this.Ripetizioni,
    this.Km,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId,
      'ActivityName': ActivityName,
      'Date': Date?.toIso8601String(),
      'Start': Start?.toIso8601String(),
      'End': End?.toIso8601String(),
      'Ripetizioni': int.tryParse(Ripetizioni.toString()),
      'Km': Km,
    };
  }

  factory Works.fromMap(Map<String, dynamic> map) {
    return Works(
      UserId: map['UserId']?.toInt(),
      ActivityName: map['ActivityName'],
      Date: map['Date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['Date'])
          : null,
      Start: map['Start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['Start'])
          : null,
      End: map['End'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['End'])
          : null,
      Ripetizioni: map['Ripetizioni']?.toInt(),
      Km: map['Km']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Works.fromJson(String source) => Works.fromMap(json.decode(source));
}

final List<Works> userworks = [
  Works(
      ActivityName: 'Run',
      Date: DateTime(2022, 01, 17),
      Start: DateTime(2022, 01, 17, 09, 30),
      End: DateTime(2022, 01, 17, 10, 00),
      Km: 5,
      UserId: 3),
  Works(
      ActivityName: 'Walk',
      Date: DateTime(2022, 01, 16),
      Start: DateTime(2022, 01, 16, 09, 30),
      End: DateTime(2022, 01, 16, 10, 00),
      Km: 3,
      UserId: 3),
  Works(
      ActivityName: 'Bicycle',
      Date: DateTime(2022, 01, 15),
      Start: DateTime(2022, 01, 15, 09, 30),
      End: DateTime(2022, 01, 15, 10, 00),
      Km: 10.4,
      UserId: 3),
  Works(
      ActivityName: 'Pull Ups',
      Date: DateTime(2022, 01, 15),
      Start: DateTime(2022, 01, 15, 16, 30),
      End: DateTime(2022, 01, 15, 17, 00),
      Ripetizioni: 20,
      UserId: 3),
  Works(
      ActivityName: 'Push Ups',
      Date: DateTime(2022, 01, 14),
      Start: DateTime(2022, 01, 14, 16, 30),
      End: DateTime(2022, 01, 14, 17, 00),
      Ripetizioni: 30,
      UserId: 3),
  Works(
      ActivityName: 'Squat',
      Date: DateTime(2022, 01, 13),
      Start: DateTime(2022, 01, 13, 16, 30),
      End: DateTime(2022, 01, 13, 17, 00),
      Ripetizioni: 20,
      UserId: 3),
];
