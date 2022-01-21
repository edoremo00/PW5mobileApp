// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Worksservice.dart';
import 'package:getfitappmobile/models/Works/worksmodel.dart';
import 'package:getfitappmobile/models/authmodel/loginmodel.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/models/workoutwrh.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/view/workout_detail.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class Workouts extends StatefulWidget {
  UserModel? model;
  Workouts({Key? key, this.model}) : super(key: key);

  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  String username = '';

  @override
  void initState() {
    super.initState();
    Worksservice()
        .Allsingleuserstats(username: widget.model?.username ?? '')
        .catchError((e) {
      print(e);
    }).then((value) {
      if (value != null) {
        setState(() {
          allsingleuser = value;
          totkm = value.Km_Tot!.toStringAsFixed(2);
          totkmgg = value.Km_Gg!.toStringAsFixed(2);
          totkmmm = value.Km_M!.toStringAsFixed(2);
          mingg = value.Min_Gg!.toStringAsFixed(2);
          minmm = value.Min_M!.toStringAsFixed(2);
        });
      }
    });

    Worksservice().Allstats().catchError((e) {
      print(e);
    }).then((value) {
      if (value != null) {
        setState(() {
          All = value;
          totkmglobal = value.Km_Tot!.toStringAsFixed(2);
          totkmggglobal = value.Km_Gg!.toStringAsFixed(2);
          totkmmmglobal = value.Km_M!.toStringAsFixed(2);
          minggglobal = value.Min_Gg!.toStringAsFixed(2);
          minmmglobal = value.Min_M!.toStringAsFixed(2);

          print(All);
        });
      }
    });

    /*Worksservice()
        .GetalluserWorkouts(username: widget.model?.username ?? '')
        .catchError((e) {
      print(e);
    }).then((value) {
      if (value != null) {
        allworkouts = value;
        print(allworkouts);
      }
    });*/
  }

  Training allsingleuser = Training();
  Training All = Training();
  //List<Wokoutwrh?> allworkouts = [];
  bool global = false;
  String totkm = '0';
  String totkmglobal = '0';
  String totkmgg = '0';
  String totkmmm = '0';
  String totkmggglobal = '0';
  String totkmmmglobal = '0';
  String mingg = '0';
  String minmm = '0';
  String minggglobal = '0';
  String minmmglobal = '0';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: Get.height * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/black/24.2.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    kThirdColor,
                    Colors.transparent,
                  ],
                ),
              ),
              height: Get.height * 0.25,
              width: Get.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
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
                          text: 'Find\t',
                          style: TextStyle(
                              fontSize: 25,
                              color: kFirstColor,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'your workouts',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        worksCarousel(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Look\t',
                  style: TextStyle(
                      fontSize: 25,
                      color: kFirstColor,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'your stats',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        statsToggle(),
        stats()
      ],
    );
  }

  Padding stats() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: kSecondColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(IcoFontIcons.ruler),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'TOT',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  global ? '$totkmglobal Km' : '$totkm Km',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              color: kThirdColor,
              height: 25,
            ),
            Row(
              children: [
                const Icon(IcoFontIcons.ruler),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Daily',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  global ? '$totkmggglobal Km' : '$totkmgg Km',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              color: kThirdColor,
              height: 25,
            ),
            Row(
              children: [
                const Icon(IcoFontIcons.ruler),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Monthly',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  global ? '$totkmmmglobal Km' : '$totkmmm Km',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              color: kThirdColor,
              height: 25,
            ),
            Row(
              children: [
                const Icon(IcoFontIcons.stopwatch),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Daily',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  global ? '$minggglobal min' : '$mingg min',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              color: kThirdColor,
              height: 25,
            ),
            Row(
              children: [
                const Icon(IcoFontIcons.stopwatch),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Monthly',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  global ? '$minmmglobal min' : '$minmm min',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row statsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            global = !global;
          }),
          child: Container(
              width: 85,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(width: 1.0, color: kFirstColor),
                    left: BorderSide(width: 1.0, color: kFirstColor),
                    right: BorderSide(width: 1.0, color: kFirstColor),
                    bottom: BorderSide(width: 1.0, color: kFirstColor),
                  ),
                  color: global ? Colors.transparent : kFirstColor,
                  boxShadow: [
                    BoxShadow(
                      color: kThirdColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 15,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.person,
                      size: 18,
                    ),
                    Text(
                      'You',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
        ),
        GestureDetector(
          onTap: () => setState(() {
            global = !global;
          }),
          child: Container(
              width: 85,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(width: 1.0, color: kFirstColor),
                    left: BorderSide(width: 1.0, color: kFirstColor),
                    right: BorderSide(width: 1.0, color: kFirstColor),
                    bottom: BorderSide(width: 1.0, color: kFirstColor),
                  ),
                  color: global ? kFirstColor : Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: kThirdColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 15,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      IcoFontIcons.world,
                      size: 18,
                    ),
                    Text(
                      'Global',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  SizedBox worksCarousel() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: userworks.length,
          itemBuilder: (BuildContext context, int index) {
            Works work = userworks[index];
            IconData icon;
            String image;
            switch (userworks[index].ActivityName) {
              case 'Walk':
                icon = IcoFontIcons.heartBeat;
                image = 'assets/images/black/25.jpg';
                break;
              case 'Run':
                icon = IcoFontIcons.runnerAlt1;
                image = 'assets/images/black/28.jpg';
                break;
              case 'Bicycle':
                icon = IcoFontIcons.cycling;
                image = 'assets/images/black/26.jpg';
                break;
              case 'Pull Ups':
                icon = IcoFontIcons.gym;
                image = 'assets/images/black/4.jpg';
                break;
              case 'Push Ups':
                icon = IcoFontIcons.muscle;
                image = 'assets/images/black/27.jpg';
                break;
              case 'Squat':
                icon = IcoFontIcons.gymAlt2;
                image = 'assets/images/black/20.jpg';
                break;
              default:
                icon = IcoFontIcons.gymAlt2;
                image = 'assets/images/black/25.jpg';
            }
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => WorkoutDetail(
                            work: work,
                          ))),
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kSecondColor),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Hero(
                      tag: image,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.topCenter,
                        height: 90,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(image), fit: BoxFit.cover),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 40,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            work.ActivityName!,
                            style: const TextStyle(
                                color: kFirstColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
            );
          }),
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
