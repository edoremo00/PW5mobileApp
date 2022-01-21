// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Authservice.dart';
import 'package:getfitappmobile/Services/Userservice.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/routes/app_pages.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/view/edit_user_page.dart';
import 'package:intl/intl.dart';

//UserModel user = UserModel();
String? username = '';

class UserProfile extends StatefulWidget {
  UserModel? user = UserModel();
  UserProfile({Key? key, this.user}) : super(key: key);

  final UserService userService = UserService();
  final Authservice authservice = Authservice();

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          header(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: kSecondColor, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  info(Icons.face, 'Name', widget.user?.name ?? ''),
                  Divider(
                    color: kThirdColor,
                    height: 30,
                  ),
                  info(Icons.face, 'Last Name', widget.user?.lastName ?? ''),
                  Divider(
                    color: kThirdColor,
                    height: 30,
                  ),
                  info(
                      Icons.date_range,
                      'Birthday',
                      DateFormat.yMMMMd('en_US')
                          .format(widget.user?.birthday ?? DateTime.now())),
                  Divider(
                    color: kThirdColor,
                    height: 30,
                  ),
                  info(Icons.email_outlined, 'Email', widget.user?.email ?? ''),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                  color: kSecondColor, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  infoButton(Icons.verified_user_outlined, 'User Agreement'),
                  Divider(
                    color: kThirdColor,
                    height: 15,
                  ),
                  infoButton(Icons.settings, 'Settings'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              await widget.authservice.logout(username: widget.user!.username!);
              Get.toNamed(Routes.WELCOME);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red[400],
              ),
              height: 50,
              width: Get.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.power_settings_new_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Sign Out",
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
        ],
      ),
    );
  }

  Row info(IconData icon, String label, String? info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              info ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )
          ],
        )
      ],
    );
  }

  TextButton infoButton(IconData icon, String label) {
    return TextButton(
      onPressed: () => {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: kLabelColor,
            size: 25,
          )
        ],
      ),
    );
  }

  Container header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 20),
      decoration: BoxDecoration(
          color: kSecondColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'imageprofile',
            child: CircleAvatar(
              radius: 22,
              backgroundColor: kFirstColor,
              child: CircleAvatar(
                radius: 20,
                child: ClipRRect(
                  child: widget.user!.photo == null
                      ? Image.asset('assets/images/users/faisal-ramdan.jpg')
                      : CachedNetworkImage(
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          fit: BoxFit.cover,
                          imageUrl: widget.user!.photo!,
                        ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 220,
            child: Text(widget.user?.username ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          ),
          GestureDetector(
            onTap: () async => await Navigator.push(
                context,
                MaterialPageRoute<UserModel>(
                    builder: (_) => EditUser(
                          user: widget.user!,
                        ))).then((value) {
              if (value != null) {
                setState(() {
                  widget.user = value;
                });
              }
            }),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.white),
                    left: BorderSide(width: 1.0, color: Colors.white),
                    right: BorderSide(width: 1.0, color: Colors.white),
                    bottom: BorderSide(width: 1.0, color: Colors.white),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kThirdColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 15,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.edit_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<UserModel?> Getuser() async {
    username = await Tokenstorage.retrieveusercredentials('usercredentials');
    if (username == null) {
      username =
          await Tokenstorage.retrieveusercredentials('usernamecredential');
      widget.user = await widget.userService.Getsingleuser(username: username!);
      if (widget.user != null) {
        return widget.user;
      }
    }
    return null;
  }
}
