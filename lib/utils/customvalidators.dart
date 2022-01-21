bool validatepasswordstructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String? validateemail(String? email) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{;|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  RegExp regExp = RegExp(pattern);
  if (regExp.hasMatch(email!)) {
    return null;
  } else {
    return 'not a valid email';
  }
}

bool passwordmatch(String password, String confirmpassword) {
  if (password.toLowerCase() == confirmpassword.toLowerCase()) {
    return true;
  }
  return false;
}
