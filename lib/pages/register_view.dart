// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, must_be_immutable

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Services/Authservice.dart';
import 'package:getfitappmobile/models/authmodel/registermodel.dart';
import 'package:getfitappmobile/routes/app_pages.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/shared/widgets/custom_form_field_widget.dart';
import 'package:getfitappmobile/shared/widgets/snackbar.dart';
import 'package:getfitappmobile/utils/customvalidators.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class RegisterView extends StatefulWidget {
  Registermodel newuser = Registermodel();
  final Authservice authservice = Authservice();
  RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool hidepass = true;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  String date = "";
  int height = 170;
  int weight = 70;
  String gender = "Not specified";
  String region = "Abruzzo";
  DateTime selectedDate = DateTime.now();

  late TextEditingController usernamecontroller;
  late TextEditingController namecontroller;
  late TextEditingController lastnamecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController birthdaycontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController weightcontroller;
  late TextEditingController heightcontroller;
  late TextEditingController confirmpasswordcontroller;

  @override
  void initState() {
    usernamecontroller = TextEditingController();
    namecontroller = TextEditingController();
    lastnamecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    birthdaycontroller = TextEditingController();
    weightcontroller = TextEditingController();
    heightcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    confirmpasswordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    namecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    weightcontroller.dispose();
    heightcontroller.dispose();
    birthdaycontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
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
                    registerForm(),
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
                                saveuserdata(widget.newuser);
                                bool registerresponse = await widget.authservice
                                    .Register(widget.newuser);
                                if (registerresponse) {
                                  showsnackbar(
                                    context: context,
                                    coloresfondo: Colors.green[800],
                                    icona: Icons.info,
                                    testo: 'Registered successfully!',
                                  );
                                  await Future.delayed(Duration(seconds: 2))
                                      .then(
                                          (value) => Get.toNamed(Routes.LOGIN));
                                } else {
                                  setState(() {
                                    isloading = false;
                                  });
                                  showsnackbar(
                                    context: context,
                                    coloresfondo: Colors.red,
                                    icona: Icons.warning,
                                    testo: 'Problem in registering',
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
                                        "Register",
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

  Form registerForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          CustomFormField(
              controller: namecontroller,
              labelText: "Name*",
              suffixicon: const Icon(
                Icons.face,
                color: kLabelColor,
              ),
              validator: RequiredValidator(errorText: "Name* is required")),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
              controller: lastnamecontroller,
              labelText: "Lastname*",
              suffixicon: const Icon(
                Icons.face,
                color: kLabelColor,
              ),
              validator: RequiredValidator(errorText: "Lastname* is required")),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
              controller: usernamecontroller,
              labelText: "Username*",
              suffixicon: const Icon(
                Icons.person,
                color: kLabelColor,
              ),
              validator: RequiredValidator(errorText: "Username* is required")),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
            controller: emailcontroller,
            labelText: "Email*",
            suffixicon: const Icon(
              Icons.mail,
              color: kLabelColor,
            ),
            validator: (String? email) {
              String pattern =
                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{;|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
              RegExp regExp = RegExp(pattern);
              if (email!.isEmpty) {
                return 'email is required';
              } else if (!regExp.hasMatch(email)) {
                return 'not a valid email';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
              labelText: "Birth Date*",
              controller: birthdaycontroller,
              readOnly: true,
              suffixicon: const Icon(
                Icons.date_range,
                color: kLabelColor,
              ),
              onTap: () => _selectDate(context),
              validator:
                  RequiredValidator(errorText: "Birth Date* is required")),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
            labelText: "Height*",
            keyboardType: TextInputType.number,
            controller: heightcontroller,
            suffixicon: Row(
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text('cm'),
                const Icon(
                  Icons.height,
                  color: kLabelColor,
                ),
              ],
            ),
            onTap: () => {},
            validator: (String? altezza) {
              if (altezza!.isEmpty) {
                return 'Height is required';
              } else if (altezza.contains('-')) {
                return "Height can't be negative";
              } else if (altezza.contains(',') || altezza.contains('.')) {
                return 'insert the value without , or .';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
            labelText: "Weight*",
            controller: weightcontroller,
            keyboardType: TextInputType.number,
            suffixicon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Kg'),
                Transform.rotate(
                  angle: 90 * math.pi / 180, //set the angel
                  child: Icon(
                    Icons.height,
                    color: kLabelColor,
                  ),
                ),
              ],
            ),
            onTap: () => {},
            validator: (String? peso) {
              if (peso!.isEmpty) {
                return 'Weight is required';
              } else if (peso.contains('-')) {
                return "Weight can't be negative";
              } else if (peso.contains(',') || peso.contains('.')) {
                return 'insert the value without , or .';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          DropdownButtonFormField(
            iconSize: 40,
            dropdownColor: kThirdColor,
            elevation: 8,
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_drop_down),
                Icon(
                  Icons.male,
                  size: 25,
                ),
                Icon(
                  Icons.female,
                  size: 25,
                ),
              ],
            ),
            decoration: InputDecoration(
              label: Text("Gender*"),
              labelStyle: const TextStyle(
                color: kLabelColor,
                fontSize: 18,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: kLabelColor,
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.white,
              )),
              //suffixIconColor: kLabelColor,
            ),
            items: <String>['Not specified', 'Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: gender,
            onChanged: (String? newValue) {
              widget.newuser.gender = newValue;
              setState(() {
                gender = newValue!;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          DropdownButtonFormField(
            iconSize: 40,
            dropdownColor: kThirdColor,
            elevation: 8,
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_drop_down),
                Icon(
                  Icons.location_pin,
                  size: 25,
                )
              ],
            ),
            decoration: InputDecoration(
              label: Text("Region*"),
              labelStyle: const TextStyle(
                color: kLabelColor,
                fontSize: 18,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: kLabelColor,
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.white,
              )),
              //suffixIconColor: kLabelColor,
            ),
            items: <String>[
              'Abruzzo',
              'Basilicata',
              'Calabria',
              'Campania',
              'Emilia-Romagna',
              'Friuli Venezia Giulia',
              'Lazio',
              'Liguria',
              'Lombardia',
              'Marche',
              'Molise',
              'Piemonte',
              'Puglia',
              'Sardegna',
              'Sicilia',
              'Toscana',
              'Trentino-Alto Adige',
              'Umbria',
              "Valle d'Aosta",
              'Veneto'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: region,
            onChanged: (String? newValue) {
              widget.newuser.region = newValue;
              setState(() {
                region = newValue!;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
            controller: passwordcontroller,
            helpertext:
                'password should at least have: 1 uppercase char, 1 number,1 special char,numbers and a minimum length of 8',
            labelText: "Password*",
            obscureText: hidepass,
            suffixicon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
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
                Icon(
                  Icons.lock,
                  color: kLabelColor,
                )
              ],
            ),
            validator: (String? password) {
              if (password!.isEmpty) {
                return 'please insert a password';
              } else if (password.length < 8) {
                return 'min length is not 8';
              } else if (password.contains(' ')) {
                return "password can't contain whitespaces";
              } else if (!validatepasswordstructure(password)) {
                return 'invalid password structure';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomFormField(
              controller: confirmpasswordcontroller,
              labelText: "Confirm Password*",
              obscureText: hidepass,
              suffixicon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
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
                  Icon(
                    Icons.lock,
                    color: kLabelColor,
                  )
                ],
              ),
              validator: (String? confirmpassword) {
                if (confirmpassword!.isEmpty) {
                  return 'please insert a confirmpassword';
                } else if (confirmpassword.length < 8) {
                  return 'min length is not 8';
                } else if (confirmpassword.contains(' ')) {
                  return "confirmpassword can't contain whitespaces";
                } else if (!validatepasswordstructure(confirmpassword)) {
                  return 'invalid password structure';
                } else if (!passwordmatch(
                    passwordcontroller.text, confirmpassword)) {
                  return 'password and confirmpassword are not equal';
                } else {
                  return null;
                }
              }),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "By signin up, I agree to the GetFit User Agreement and Privacy Policy.",
              style: TextStyle(color: kLabelColor),
            ),
          )
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: "Select Birth Date",
      cancelText: "Cancel",
      confirmText: "Select",
      fieldHintText: "dd/mm/yyyy",
      fieldLabelText: "Birth Date",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              onBackground: kThirdColor,
              surface: kThirdColor,
              background: kThirdColor,
              primary: kLabelColor, // header background color
              onPrimary: kThirdColor, // header text color
              onSurface: Colors.white, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: kFirstColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDate) {
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final String formatDate = dateFormatter.format(selected);
      setState(() {
        birthdaycontroller.text = formatDate;
      });
    }
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
                    "Sign Up",
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
              image: AssetImage("assets/images/black/20.2.jpg"),
              fit: BoxFit.cover)),
    );
  }

  Registermodel saveuserdata(Registermodel tosave) {
    tosave.username = usernamecontroller.text;
    tosave.lastName = lastnamecontroller.text;
    tosave.gender = gender;
    tosave.password = passwordcontroller.text;
    tosave.confermaPassword = confirmpasswordcontroller.text;
    tosave.email = emailcontroller.text;
    tosave.name = namecontroller.text;
    tosave.height = heightcontroller.text;
    tosave.weight = weightcontroller.text;
    tosave.birthday = DateTime.parse(birthdaycontroller.text);
    tosave.region == null ? tosave.region = region : tosave.region;
    return tosave;
  }
}
