import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Services/Authservice.dart';
import 'package:getfitappmobile/Services/Userservice.dart';
import 'package:getfitappmobile/routes/app_pages.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/shared/widgets/custom_form_field_widget.dart';
import 'package:getfitappmobile/shared/widgets/snackbar.dart';
import 'package:getfitappmobile/utils/customvalidators.dart';

class ForgetPassword extends StatefulWidget {
  final UserService userService = UserService();
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool hidepassword = true;
  bool isloading = false;
  String username = '';
  String oldpassword = '';
  String newpassword = '';
  late TextEditingController usernamecontroller;
  late TextEditingController oldpasswordcontroller;
  late TextEditingController newpassswordcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernamecontroller = TextEditingController();
    oldpasswordcontroller = TextEditingController();
    newpassswordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernamecontroller.dispose();
    oldpasswordcontroller.dispose();
    newpassswordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kThirdColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                    forgetPassForm(),
                    const SizedBox(height: 40),
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

                                username = usernamecontroller.text;
                                oldpassword = oldpasswordcontroller.text;
                                newpassword = newpassswordcontroller.text;

                                bool resetpasswordresult =
                                    await widget.userService.Forgetppassword(
                                        username: username,
                                        oldpassword: oldpassword,
                                        newpassword: newpassword);
                                setState(() {
                                  isloading = false;
                                });
                                resetpasswordresult
                                    ? showsnackbar(
                                        context: context,
                                        coloresfondo: Colors.green[800],
                                        icona: Icons.info,
                                        testo: 'Password changed successfully!',
                                      )
                                    : showsnackbar(
                                        context: context,
                                        coloresfondo: Colors.red[700],
                                        icona: Icons.warning,
                                        testo: 'error in changing password!',
                                      );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kFirstColor,
                              ),
                              height: 50,
                              width: Get.width * 0.5,
                              child: const Center(
                                child: Text(
                                  "Submit",
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
                            onPressed: () => Get.toNamed(Routes.LOGIN),
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
                                  "Cancel",
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

  Form forgetPassForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          CustomFormField(
            controller: usernamecontroller,
            labelText: "Username*",
            suffixicon: const Icon(
              Icons.person,
              color: kLabelColor,
            ),
            validator: RequiredValidator(errorText: "Username* is required"),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomFormField(
            controller: oldpasswordcontroller,
            obscureText: hidepassword,
            labelText: "oldpassword*",
            suffixicon: IconButton(
              icon: hidepassword
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              color: kLabelColor,
              onPressed: () {
                setState(() {
                  hidepassword = !hidepassword;
                });
              },
            ),
            validator: (String? oldpassword) {
              if (oldpassword!.isEmpty) {
                return 'oldpassword is required';
              } else if (oldpassword.contains(' ')) {
                return "oldpassword can't contain spaces";
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomFormField(
            controller: newpassswordcontroller,
            obscureText: hidepassword,
            helpertext:
                'password should at least have: 1 uppercase char, 1 number,1 special char,numbers and a minimum length of 8',
            labelText: "newpassword*",
            suffixicon: IconButton(
              icon: hidepassword
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              color: kLabelColor,
              onPressed: () {
                setState(() {
                  hidepassword = !hidepassword;
                });
              },
            ),
            validator: (String? newpassword) {
              if (newpassword!.isEmpty) {
                return 'please insert a newpassword';
              } else if (newpassword.length < 8) {
                return 'min length is not 8';
              } else if (newpassword.contains(' ')) {
                return "newpassword can't contain whitespaces";
              } else if (!validatepasswordstructure(newpassword)) {
                return 'invalid newpassword structure';
              } else {
                return null;
              }
            },
          ),
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
      height: Get.height * 0.55,
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
                    "Forget Password",
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
      height: Get.height * 0.55,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/black/14.2.jpg"),
              fit: BoxFit.cover)),
    );
  }
}
