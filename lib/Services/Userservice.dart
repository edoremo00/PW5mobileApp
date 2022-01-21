import 'dart:convert';

import 'package:getfitappmobile/APIurls/constanturls.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// ignore_for_file: file_names

class UserService {
  // ignore: non_constant_identifier_names

  Future<bool> Forgetppassword(
      {required String username,
      required String oldpassword,
      required String newpassword}) async {
    try {
      Response r = await http.put(
        Uri.parse('$userurl/ResetPassword/$username/$oldpassword/$newpassword'),
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

  Future<UserModel?> Getsingleuser({required String username}) async {
    try {
      Response r = await http.get(
        Uri.parse('$userurl/GetSingle/$username'),
      );
      if (r.statusCode == 200) {
        Map<String, dynamic> userresponse = jsonDecode(r.body);
        print(userresponse);
        UserModel model = UserModel.fromMap(userresponse);
        return model;
      } else {
        //throw 'unable to retrieve user';
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> Updateuser({required UserModel model}) async {
    try {
      Response r = await http.put(
        Uri.parse('$userurl/ModifyFlutter'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: model.toJson(),
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

  Future<StreamedResponse?> Uploadprofilepicture(
      {required XFile file, required String username}) async {
    try {
      MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('$picsbaseurl/Add/$username'),
      )..files.add(await MultipartFile.fromPath('file', file.path));
      StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> Deleteprofilepicture({required String username}) async {
    try {
      Response r =
          await http.delete(Uri.parse("$picsbaseurl/Delete/$username"));
      if (r.statusCode == 200) {
        bool response = r.body == 'true';
        return response;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
