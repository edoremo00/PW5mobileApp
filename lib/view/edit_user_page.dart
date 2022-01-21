// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_if_null_operators

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Services/Userservice.dart';
import 'package:getfitappmobile/core.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/shared/widgets/custom_form_field_widget.dart';
import 'package:getfitappmobile/shared/widgets/snackbar.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

import 'package:intl/intl.dart';

class EditUser extends StatefulWidget {
  UserModel user;
  EditUser({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  bool cameraselected = false;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController usernamecontroller;
  late TextEditingController namecontroller;
  late TextEditingController lastnamecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController birthdaycontroller;
  late TextEditingController weightcontroller;
  late TextEditingController heightcontroller;
  @override
  void initState() {
    usernamecontroller = TextEditingController();
    namecontroller = TextEditingController();
    lastnamecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    birthdaycontroller = TextEditingController();
    weightcontroller = TextEditingController();
    heightcontroller = TextEditingController();
    usernamecontroller.text = widget.user.username!;
    namecontroller.text = widget.user.name!;
    lastnamecontroller.text = widget.user.lastName!;
    emailcontroller.text = widget.user.email!;
    birthdaycontroller.text =
        DateFormat('yyyy-MM-dd').format(widget.user.birthday!);
    weightcontroller.text = widget.user.weight.toString() == 'null'
        ? ''
        : widget.user.weight.toString(); //widget.user.weight.toString() ?? '';
    heightcontroller.text = widget.user.height.toString() == 'null'
        ? ''
        : widget.user.height.toString(); //widget.user.height.toString() ?? '';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kThirdColor,
        body: Column(children: [
          Container(
              decoration: const BoxDecoration(
                  color: kSecondColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              height: Get.height * 0.30,
              width: Get.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                // ignore: prefer_const_literals_to_create_immutables
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, widget.user),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.white),
                                left:
                                    BorderSide(width: 1.0, color: Colors.white),
                                right:
                                    BorderSide(width: 1.0, color: Colors.white),
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.white),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kThirdColor.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: Get.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: kFirstColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              Hero(
                                tag: 'imageprofile',
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: kFirstColor,
                                  child: CircleAvatar(
                                    radius: 48,
                                    child: ClipRRect(
                                      child: widget.user.photo == null
                                          ? Image.asset(
                                              'assets/images/users/faisal-ramdan.jpg')
                                          : CachedNetworkImage(
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              fit: BoxFit.cover,
                                              imageUrl: widget.user.photo!,
                                            ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  bool? uploadphotochoice =
                                      await bottomsheet(context);
                                  if (uploadphotochoice != null) {
                                    XFile? chosenpicture =
                                        await _picker.pickImage(
                                      source: uploadphotochoice
                                          ? ImageSource.camera
                                          : ImageSource.gallery,
                                    );

                                    if (chosenpicture != null) {
                                      if (validatefileextension(
                                          chosenpicture)) {
                                        //chiamata api
                                        //copyoldifnull(newone);
                                        StreamedResponse? respnse =
                                            await UserService()
                                                .Uploadprofilepicture(
                                          file: chosenpicture,
                                          username: widget.user.username ?? '',
                                        );

                                        if (respnse?.reasonPhrase == 'OK') {
                                          String newimageurl = await respnse!
                                              .stream
                                              .bytesToString();
                                          setState(() {
                                            widget.user.photo = newimageurl;
                                            //widget.toupdate.imagelink = newimageurl;
                                            //newone.imagelink = newimageurl;
                                          });
                                          //Navigator.of(context).pop(user);
                                          //passo il nuovo valore alla pagina precedente che aggiornerà anche lei la UI
                                        }
                                      } else {
                                        showsnackbar(
                                          context: context,
                                          coloresfondo: Colors.red[700],
                                          icona: Icons.warning,
                                          testo: 'unsupported file type',
                                        );
                                        return; //file non valido
                                      }
                                    } else {
                                      return; //file non selezionato
                                    }
                                  } else {
                                    return;
                                  }
                                },
                                child: Text(
                                  'Change photo profile',
                                  style: TextStyle(
                                      color: kFirstColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
            padding: const EdgeInsets.all(20),
            child: registerForm(),
          )))
        ]));
  }

  Form registerForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              controller: emailcontroller,
              labelText: "Email*",
              keyboardType: TextInputType.emailAddress,
              suffixicon: const Icon(
                Icons.mail,
                color: kLabelColor,
              ),
              validator: RequiredValidator(errorText: "Email* is required")),
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
              validator: RequiredValidator(errorText: "Height* is required")),
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
              validator: RequiredValidator(errorText: "Weight* is required")),
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
            value: widget.user.gender,
            onChanged: (String? newValue) {
              widget.user.gender = newValue;
              setState(() {
                widget.user.gender = newValue!;
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
            value: widget.user.region,
            onChanged: (String? newValue) {
              widget.user.region = newValue;
              setState(() {
                widget.user.region = newValue!;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                if (_formKey.currentState!.validate()) {
                  updateuser(widget.user);
                  bool updateuserresponse =
                      await UserService().Updateuser(model: widget.user);
                  setState(() {
                    isloading = false;
                  });
                  updateuserresponse
                      ? showsnackbar(
                          context: context,
                          coloresfondo: Colors.greenAccent[400],
                          testo:
                              '${usernamecontroller.text} updated successfully',
                          icona: Icons.info,
                        )
                      : showsnackbar(
                          context: context,
                          coloresfondo: Colors.red[700],
                          testo: 'problem in updating. try again later',
                          icona: Icons.warning,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    isloading
                        ? Text(
                            "Please wait",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "Save profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: widget.user.birthday!,
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
    if (selected != null) {
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final String formatDate = dateFormatter.format(selected);
      setState(() {
        birthdaycontroller.text = formatDate;
      });
    }
  }

  UserModel updateuser(UserModel toupdate) {
    toupdate.birthday == null
        ? toupdate.birthday = widget.user.birthday
        : toupdate.birthday = DateTime.tryParse(birthdaycontroller.text);
    toupdate.email == null
        ? toupdate.email = widget.user.email
        : toupdate.email = emailcontroller.text;
    toupdate.gender == null
        ? toupdate.gender = widget.user.gender
        : toupdate.gender;
    toupdate.height == null && widget.user.height == null
        ? toupdate.height = double.parse(heightcontroller.text)
        : toupdate.height = double.parse(heightcontroller.text);
    toupdate.weight == null && widget.user.weight == null
        ? toupdate.weight = double.parse(weightcontroller.text)
        : toupdate.weight = double.parse(weightcontroller.text);
    toupdate.region ??= widget.user.region;
    toupdate.lastName == null
        ? toupdate.lastName = widget.user.lastName
        : toupdate.lastName = lastnamecontroller.text;
    toupdate.username == null
        ? toupdate.username = widget.user.username
        : toupdate.username = usernamecontroller.text;
    toupdate.name == null
        ? toupdate.name = widget.user.name
        : toupdate.name = namecontroller.text;
    toupdate.id ??= widget.user.id;
    toupdate.photo ?? widget.user.photo;

    return toupdate;
  }

  Future<bool?> bottomsheet(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Scatta nuova'),
                onTap: () {
                  cameraselected = true;
                  Navigator.pop(context, cameraselected);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Scegli esistente'),
                onTap: () {
                  cameraselected = false;
                  Navigator.pop(context, cameraselected);
                },
              ),
              widget.user.photo != null
                  ? ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text(
                        'Rimuovi foto profilo',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        bool deleteprofileresponse = await UserService()
                            .Deleteprofilepicture(
                                username: usernamecontroller.text);
                        if (deleteprofileresponse) {
                          setState(() {
                            widget.user.photo = null;
                          });
                        }
                      },
                    )
                  : Container()
            ],
          );
        });
  }

  bool validatefileextension(XFile filetovalidate) {
    List<String> acceptedextensions = ['.jpg', '.png', '.jpeg'];
    if (!acceptedextensions.contains(Path.extension(filetovalidate.name))) {
      return false; //file in formato non valido
    } else {
      return true;
    }
  }
}
