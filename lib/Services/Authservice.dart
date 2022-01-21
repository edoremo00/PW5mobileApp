// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/models/authmodel/loginmodel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:getfitappmobile/APIurls/constanturls.dart';
import 'package:getfitappmobile/models/authmodel/registermodel.dart';

class Authservice {
  Future<bool> Register(Registermodel model) async {
    try {
      Response r = await http.post(Uri.parse('$authbaseurl/newUser'),
          body: model.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });

      if (r.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(Loginmodel user) async {
    Response r = await http.post(Uri.parse("$authbaseurl/Login"),
        body: user.toJson(),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        }).catchError((e) => print(e));
    if (r.statusCode == 200) {
      Map<String, dynamic> jwt = jsonDecode(r.body);
      //chiamare flutter secure storage per salvare token
      await Tokenstorage.savetoken('token', jwt['token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout({required String username}) async {
    http.Response r = await http.post(
      Uri.parse("$logsbaseurl/LogOut/$username"),
    );
    if (await Tokenstorage.removeuserfromstorage('usercredentials') &&
        await Tokenstorage.removeuserfromstorage('usernamecredential') &&
        await Tokenstorage.removetokenfromstorage('token')) {
      print('cancellati token e utenti da storage');
    }
    /*.catchError((e) async {
      await Tokenstorage.removeuserfromstorage('usercredentials');
      await Tokenstorage.removeuserfromstorage('usernamecredential');
      await Tokenstorage.removetokenfromstorage('token');
    });*/
    if (r.statusCode == 200) {
      return true;
    } else {
      print('chiamata logout non a buon fine');
      await Tokenstorage.removeuserfromstorage('usercredentials');
      await Tokenstorage.removeuserfromstorage('usernamecredential');
      await Tokenstorage.removetokenfromstorage('token');
      return false;
    }
  }
}
