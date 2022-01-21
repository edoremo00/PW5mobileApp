import 'dart:async';
import 'dart:convert';

import 'package:getfitappmobile/APIurls/constanturls.dart';
import 'package:getfitappmobile/models/Works/worksmodel.dart';
import 'package:getfitappmobile/models/workoutwrh.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
// ignore_for_file: file_names

class Worksservice {
  // ignore: non_constant_identifier_names
  Future<bool> Addworkout(Works workoutmodel) async {
    try {
      Response r = await http.post(
        Uri.parse('$worksurl/AddWork'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: workoutmodel.toJson(),
      );

      if (r.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Wokoutwrh?>?> GetalluserWorkouts(
      {required String username}) async {
    try {
      Response r = await http.get(
          Uri.parse('$workswrhbaseurl/GetAllWorkOut_User/$username'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });

      if (r.statusCode == 200) {
        List<dynamic> body = jsonDecode(r.body);
        List<Wokoutwrh> alluserworkouts = body
            .map(
              (workouts) => Wokoutwrh.fromMap(workouts),
            )
            .toList();
        return alluserworkouts;
      } else if (r.statusCode == 204) {
        return [];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Training?> Allsingleuserstats({required String username}) async {
    try {
      Response r = await http
          .get(Uri.parse('$workswrhbaseurl/WorkOut_User/$username'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      });
      if (r.statusCode == 200) {
        Map<String, dynamic> allsingleuserstatsresponse = jsonDecode(r.body);
        print(allsingleuserstatsresponse);
        Training model = Training.fromMap(allsingleuserstatsresponse);
        return model;
      } else if (r.statusCode == 204) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Training?> Allstats() async {
    try {
      Response r = await http
          .get(Uri.parse('$workswrhbaseurl/WorkOut_AllUsers'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      });
      if (r.statusCode == 200) {
        Map<String, dynamic> Allstatsresponse = jsonDecode(r.body);
        print(Allstatsresponse);
        Training response = Training.fromMap(Allstatsresponse);
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
