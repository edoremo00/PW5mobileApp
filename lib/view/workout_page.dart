// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/models/workout_item_model.dart';
import 'package:getfitappmobile/shared/widgets/stopwatch_widget.dart';
import 'package:getfitappmobile/shared/xcore.dart';

class WorkoutPage extends StatefulWidget {
  final WorkoutItemModel workout;
  final UserModel? user;
  const WorkoutPage({Key? key, required this.workout, this.user})
      : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool closeworkout = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Stop Training?, data will be lost"),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              closeworkout = true;
                              Navigator.of(context).pop(true);
                            },
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            icon: Icon(Icons.check),
                            label: Text('yes'),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              closeworkout = false;
                              Navigator.of(context).pop(false);
                            },
                            child: Text("no",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
        return closeworkout;
      },
      child: Scaffold(
        backgroundColor: kThirdColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [backgroundImage(), titleSubtitle()],
              ),
              SizedBox(
                height: 10,
              ),
              StopWatch(workout: widget.workout, user: widget.user)
            ],
          ),
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    bool closeworkout = false;
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Stop Training?, data will be lost"),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          closeworkout = true;
                                          Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        icon: Icon(Icons.check),
                                        label: Text('yes'),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          closeworkout = false;

                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(
                                          "no",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    if (closeworkout) {
                      Navigator.pop(context);
                    }
                  },
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
                    child: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
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
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workout.name,
                    style: const TextStyle(
                        fontSize: 40,
                        color: kFirstColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.workout.description,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Hero backgroundImage() {
    return Hero(
      tag: widget.workout.image,
      child: Container(
        height: Get.height * 0.40,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(widget.workout.image), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
