// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Tokenstorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
        encryptedSharedPreferences: true), //così dati salvati sono criptati
  );

  static Future<void> savetoken(String key, String value) async =>
      await _storage.write(key: key, value: value);

  static Future<void> saveusercredentials(String key, String value) async =>
      await _storage.write(key: key, value: value);

  static Future<String?> retrieveusercredentials(String key) async {
    String? token = await _storage.read(key: key);
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  static Future<String?> retrievetokenvalue(String key) async {
    String? token = await _storage.read(key: key);
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  static void Logout() {
    removetokenfromstorage('usercredentials');
    removeuserfromstorage('usernamecredential');
  }

  static Future<bool> removetokenfromstorage(String key) async {
    //logout
    await _storage.delete(key: key);
    String? istokendeleted = await retrievetokenvalue('token');
    return (istokendeleted == null ? true : false);
  }

  static Future<bool> removeuserfromstorage(String key) async {
    //logout
    await _storage.delete(key: key);
    String? isuserremoved = await retrieveusercredentials('usercredentials');
    String? istokenremoved = await retrievetokenvalue('token');
    String? isusernameremoved = await retrieveusercredentials('username');

    if (isuserremoved == null &&
        istokenremoved == null &&
        isusernameremoved == null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> Decodejwttoken(String token) async {
    String? token = await retrievetokenvalue('token');
    if (token != null) {
      Map<String, dynamic> jwttokenpayload = Jwt.parseJwt(token);
      return jwttokenpayload;
    }
    return null;
  }
}
