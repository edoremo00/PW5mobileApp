// ignore_for_file: prefer_const_constructors, unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Userservice.dart';
import 'package:getfitappmobile/models/authmodel/loginmodel.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/models/workout_item_model.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/view/user_profile_page.dart';
import 'package:getfitappmobile/view/workout_page.dart';

class HomePage extends StatefulWidget {
  UserModel? model;
  String? username;
  HomePage({Key? key, this.model, this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getlogged().then((value) {
      if (value != null) {
        UserService().Getsingleuser(username: value).then((value) {
          if (value != null) {
            setState(() {
              widget.model = value;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: Get.height * 0.40,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/black/24.2.jpg"),
                      fit: BoxFit.cover)),
            ),
            Container(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 115,
                    ),
                    RichText(
                      text: const TextSpan(
                        text: 'GET\t',
                        style: TextStyle(
                            fontFamily: "Bebas",
                            fontSize: 40,
                            letterSpacing: 5),
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
                      alignment: Alignment.bottomLeft,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Popular\t',
                          style: TextStyle(
                              fontSize: 25,
                              color: kFirstColor,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'workouts',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hey,\t',
                      style: TextStyle(fontSize: 25, color: kFirstColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: username ?? //widget.model!.username ??
                              '', //USERNAME SARà PASSATO DA PAGINA LOGIN PER FARE QUI IL DISPLAY OPPURE CHIAMATA A SHAREDPREFERENCES PER PRENDERE NOME
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: kFirstColor,
                    child: CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                        child: widget.model!.photo == null
                            ? Image.asset(
                                'assets/images/users/faisal-ramdan.jpg')
                            : CachedNetworkImage(
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                fit: BoxFit.cover,
                                imageUrl: widget.model!.photo!,
                              ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: workoutsItems.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => WorkoutPage(
                              user: widget.model,
                              workout: workoutsItems[index],
                            ))),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 15, 10),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kSecondColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(120, 10, 10, 10),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                workoutsItems[index].icon,
                                size: 35,
                                color: kLabelColor,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      workoutsItems[index].name,
                                      style: TextStyle(
                                          color: kFirstColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(workoutsItems[index].description)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 15,
                      bottom: 15,
                      child: Hero(
                        tag: workoutsItems[index].image,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                            image: AssetImage(workoutsItems[index].image),
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<String?> getlogged() async {
    String? usercredentials =
        await Tokenstorage.retrieveusercredentials('usercredentials');

    if (usercredentials != null) {
      String saveduser = Loginmodel.fromJson(usercredentials).Username;
      return saveduser;
    } else {
      String? username =
          await Tokenstorage.retrieveusercredentials('usernamecredential');
      return username;
    }
  }
}
