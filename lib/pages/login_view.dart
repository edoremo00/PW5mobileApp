// ignore_for_file: prefer_const_constructors, unused_import, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Authservice.dart';
import 'package:getfitappmobile/core.dart';
import 'package:getfitappmobile/models/authmodel/loginmodel.dart';
import 'package:getfitappmobile/shared/widgets/custom_form_field_widget.dart';
import 'package:getfitappmobile/shared/widgets/snackbar.dart';
import 'package:getfitappmobile/view/adminerrorpage.dart';

class LoginView extends StatefulWidget {
  final Authservice authservice = Authservice();
  Loginmodel model = Loginmodel(Password: '', Username: '');
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool keepmesignedin = false;
  bool hidepass = true;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;

  @override
  void initState() {
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kThirdColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [backgroundImage(), titleSubtitle()],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLogin(),
                    // const SizedBox(height: 15),
                    forgetButton(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: CheckboxListTile(
                        title: const Text(
                          'Keep me signed in',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: keepmesignedin,
                        onChanged: (value) {
                          setState(() {
                            keepmesignedin = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                saveuserdata(widget.model);
                                keepmesignedin
                                    ? await Tokenstorage.saveusercredentials(
                                        'usercredentials',
                                        widget.model.toJson(),
                                      )
                                    : await Tokenstorage.saveusercredentials(
                                        'usernamecredential',
                                        widget.model.Username,
                                      );

                                bool loginresult = await widget.authservice
                                    .login(widget.model);

                                setState(() {
                                  isloading = false;
                                });

                                if (loginresult) {
                                  if (await checkadmin() == true) {
                                    Get.toNamed(Routes.ADMINERRORPAGE);
                                  } else {
                                    Get.offAllNamed(Routes.HOME);
                                  }
                                } else {
                                  showsnackbar(
                                    context: context,
                                    coloresfondo: Colors.red,
                                    icona: Icons.warning,
                                    testo: 'wrong credentials',
                                  );
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kFirstColor,
                              ),
                              height: 50,
                              width: Get.width * 0.5,
                              child: Center(
                                child: isloading
                                    ? Text(
                                        'Please wait',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.REGISTER),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 1, color: Colors.white),
                              ),
                              height: 50,
                              width: Get.width * 0.5,
                              child: const Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align forgetButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () => Get.toNamed(Routes.FORGET_PASSWORD),
          child: const Text(
            "Forgot your password?",
            style: TextStyle(color: Colors.white, fontSize: 12),
          )),
    );
  }

  Form formLogin() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          CustomFormField(
            controller: usernamecontroller,
            labelText: "Username*",
            suffixicon: Icon(
              Icons.person,
              color: kLabelColor,
            ),
            validator: (String? username) {
              if (username!.isEmpty) {
                return 'username is required';
              } else if (username.contains(' ')) {
                return "username can't contain spaces";
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          CustomFormField(
            controller: passwordcontroller,
            labelText: "Password*",
            obscureText: hidepass,
            suffixicon: IconButton(
              color: kLabelColor,
              icon: hidepass
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  hidepass = !hidepass;
                });
              },
            ),
            validator: (String? password) {
              if (password!.isEmpty) {
                return 'password is required';
              } else if (password.contains(' ')) {
                return "password can't contain spaces";
              } else {
                return null;
              }
            },
          )
        ],
      ),
    );
  }

  Container titleSubtitle() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            kThirdColor,
            Colors.transparent,
          ])),
      height: Get.height * 0.40,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            RichText(
              text: const TextSpan(
                text: 'GET\t',
                style: TextStyle(
                    fontFamily: "Bebas", fontSize: 30, letterSpacing: 5),
                children: <TextSpan>[
                  TextSpan(
                    text: 'FIT',
                    style: TextStyle(color: kFirstColor),
                  )
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Train and live the new experience of \nexercising at home",
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container backgroundImage() {
    return Container(
      height: Get.height * 0.40,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/black/12.2.jpg"),
              fit: BoxFit.cover)),
    );
  }

  //logica login
  Loginmodel saveuserdata(Loginmodel tosave) {
    tosave.Username = usernamecontroller.text;
    tosave.Password = passwordcontroller.text;
    return tosave;
  }

  Future<bool> checkadmin() async {
    Map<String, dynamic>? decodetoken =
        await Tokenstorage.Decodejwttoken('token');
    if (decodetoken != null) {
      String role = decodetoken[
              "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"]
          .toString();
      return ((role == 'Admin' ||
              role == '[SuperAdmin, Admin, Basic, Ban] ' ||
              role == '[Basic, Ban]')
          ? true
          : false);
    }
    return false;
  }
}
