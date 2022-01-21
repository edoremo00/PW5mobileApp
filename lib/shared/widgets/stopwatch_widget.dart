// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_declarations, non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/Authutils/tokenstorage.dart';
import 'package:getfitappmobile/Services/Worksservice.dart';
import 'package:getfitappmobile/models/Works/worksmodel.dart';
import 'package:getfitappmobile/models/user_model.dart';
import 'package:getfitappmobile/models/workout_item_model.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:getfitappmobile/shared/widgets/custom_form_field_widget.dart';
import 'package:getfitappmobile/shared/widgets/snackbar.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class StopWatch extends StatefulWidget {
  final Worksservice _service = Worksservice();
  final UserModel? user;
  Works w = Works();
  final WorkoutItemModel workout;
  StopWatch({Key? key, required this.workout, this.user}) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String distanza = 0.toStringAsPrecision(3);
  Timer? getposevery5sec;
  List<Position> pos = [];
  int timerinteractions = 0;
  int index = 0;
  double somma = 0;
  Duration duration = const Duration();
  bool isrestart = false;
  Timer? timer;
  late TextEditingController repetitionscontoller;

  @override
  void initState() {
    repetitionscontoller = TextEditingController();
    repetitionscontoller.text = '00';
    super.initState();
    Getpermission();
    //reset();
  }

  @override
  void dispose() {
    getposevery5sec?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildtime(),
        SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 40,
        ),
        widget.workout.name == 'Walk' ||
                widget.workout.name == 'Run' ||
                widget.workout.name == 'Bicycle'
            ? distance()
            : GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: kFirstColor),
                          left: BorderSide(width: 1.0, color: kFirstColor),
                          right: BorderSide(width: 1.0, color: kFirstColor),
                          bottom: BorderSide(width: 1.0, color: kFirstColor),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kThirdColor.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 15,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Form(
                          key: _formkey,
                          child: CustomFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textAlignCenter: TextAlign.center,
                            controller: repetitionscontoller,
                            keyboardType: TextInputType.number,
                            validator: (String? ripetizioni) {
                              if (ripetizioni!.contains(',') ||
                                  ripetizioni.contains('.')) {
                                return 'invalid format';
                              } else if (ripetizioni.isEmpty) {
                                return 'min value is 0';
                              } else if (ripetizioni.contains('-')) {
                                return 'invalid value';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'repetitions',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Bebas",
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: 40,
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () async {
              if (duration.inMinutes >= Duration(minutes: 1).inMinutes) {
                if (_formkey.currentState!.validate()) {
                  getposevery5sec?.cancel();
                  Saveuserworkout(widget.w);
                  await widget._service.Addworkout(widget.w).then(
                    (value) {
                      reset();
                      showsnackbar(
                        context: context,
                        icona: Icons.info,
                        coloresfondo: kFirstColor,
                        testo: 'Workout saved successfully',
                      );
                    },
                  );
                } else {
                  showsnackbar(
                    context: context,
                    icona: Icons.warning,
                    coloresfondo: Colors.red[700],
                    testo: 'please insert a valid value before submit',
                  );
                }
              } else {
                reset();
                getposevery5sec?.cancel();
                showsnackbar(
                  context: context,
                  icona: Icons.warning,
                  coloresfondo: Colors.red[700],
                  testo: 'workout too short for being saved',
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
                children: const [
                  Icon(
                    IcoFontIcons.racingFlagAlt,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Save Workout",
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
    );
  }

  Column distance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 90),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: kFirstColor),
                left: BorderSide(width: 1.0, color: kFirstColor),
                right: BorderSide(width: 1.0, color: kFirstColor),
                bottom: BorderSide(width: 1.0, color: kFirstColor),
              ),
              boxShadow: [
                BoxShadow(
                  color: kThirdColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 15,
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        distanza,
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: "Bebas",
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Km',
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Bebas",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Text(
                    'distance',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Bebas",
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void reset() {
    /*getposevery5sec?.cancel();
    Saveuserworkout(widget.w); //salva dati finali workout
    Map<String, dynamic>? jwt = await Tokenstorage.Decodejwttoken('token');
    if (jwt != null) {
      widget.w.UserId = int.parse(jwt['sub']);
    }
    await widget._service.Addworkout(widget.w);*/
    //setState(() => duration = const Duration());
    //non prendere più posizione
    setState(() {
      duration = const Duration();
      distanza = 0.toStringAsPrecision(3);
    });
    timer?.cancel();
    getposevery5sec?.cancel();
  }

  addTime() {
    final addseconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addseconds;
      duration = Duration(seconds: seconds);
    });
  }

  void starttimer({bool resets = false}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    // _getCurrentLocation(pos);
    _getCurrentLocation(pos);
    if (isrestart == false) {
      widget.w.Date = DateTime.now();
      widget.w.Start = DateTime.now();
    }
    isrestart = true;
  }

  buidTimecard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kThirdColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          header,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget buildButtons() {
    final isrunning = timer == null ? false : timer!.isActive;
    final iscompleted = duration.inSeconds > 0;
    return isrunning || iscompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                decoration: ShapeDecoration(
                    shape: const CircleBorder(), color: Colors.grey[700]),
                child: IconButton(
                  iconSize: 60,
                  icon: Icon(
                    isrunning ? Icons.pause : Icons.play_arrow,
                    color: isrunning ? Colors.yellow : Colors.greenAccent,
                  ),
                  onPressed: () {
                    if (isrunning) {
                      stopTimer(resets: false);
                      getposevery5sec?.cancel();
                    } else {
                      starttimer(resets: false);
                      //riascoltare posizione utente
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Ink(
                decoration: ShapeDecoration(
                    shape: const CircleBorder(), color: Colors.grey[700]),
                child: IconButton(
                  iconSize: 60,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: stopTimer,
                ),
              ),
            ],
          )
        : Ink(
            decoration: ShapeDecoration(
                shape: const CircleBorder(), color: Colors.grey[700]),
            child: IconButton(
              iconSize: 60,
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.greenAccent,
              ),
              onPressed: () {
                starttimer();
              },
            ),
          );
  }

  Widget buildtime() {
    final isrunning = timer == null ? false : timer!.isActive;
    final iscompleted = duration.inSeconds > 0;
    String twodigits(int n) => n.toString().padLeft(2, '0');
    final hours = twodigits(duration.inHours);
    final minutes = twodigits(duration.inMinutes.remainder(60));
    final seconds = twodigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            if (isrunning) {
              stopTimer(resets: false);
              getposevery5sec?.cancel();
            } else {
              starttimer(resets: false);
              //riascoltare posizione utente
            }
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kFirstColor),
                  left: BorderSide(width: 1.0, color: kFirstColor),
                  right: BorderSide(width: 1.0, color: kFirstColor),
                  bottom: BorderSide(width: 1.0, color: kFirstColor),
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
              isrunning ? Icons.pause : Icons.play_arrow,
              size: 50,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 90),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: kFirstColor),
                    left: BorderSide(width: 1.0, color: kFirstColor),
                    right: BorderSide(width: 1.0, color: kFirstColor),
                    bottom: BorderSide(width: 1.0, color: kFirstColor),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kThirdColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 15,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        hours,
                        style: TextStyle(fontSize: 50, fontFamily: "Bebas"),
                      ),
                      Text(
                        "hours",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Bebas",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 42, fontFamily: "Bebas"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Text(
                        minutes,
                        style: TextStyle(fontSize: 50, fontFamily: "Bebas"),
                      ),
                      Text(
                        "minutes",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Bebas",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ":",
                    style: TextStyle(fontSize: 42, fontFamily: "Bebas"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Text(
                        seconds,
                        style: TextStyle(fontSize: 50, fontFamily: "Bebas"),
                      ),
                      Text(
                        "seconds",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Bebas",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            stopTimer(resets: true);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kFirstColor),
                  left: BorderSide(width: 1.0, color: kFirstColor),
                  right: BorderSide(width: 1.0, color: kFirstColor),
                  bottom: BorderSide(width: 1.0, color: kFirstColor),
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
              Icons.refresh,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }

  Future<LocationPermission> Getpermission() async {
    LocationPermission userpermissionchoice =
        await Geolocator.requestPermission();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('cant use gps');
      return permission;
    } else if (permission == LocationPermission.deniedForever) {
      print('cant use gps forever');
      return permission;
    }
    return permission;
  }

  Works Saveuserworkout(Works tosave) {
    widget.w.End = DateTime.now();
    widget.w.Km = double.parse(distanza);
    widget.w.Ripetizioni = int.tryParse(
        repetitionscontoller.text); //VERRANNO INSERITE DALL'UTENTE O BOH
    widget.w.UserId = widget.user?.id;
    widget.w.ActivityName = widget.workout.name;
    print(widget.w.End);
    print(widget.w.Km);
    print(widget.w.Ripetizioni);
    print(widget.w.UserId);
    print(widget.w.ActivityName);

    return tosave;
  }

  //calcolo distanza e GPS

  static final R = 6372.8;
  static double haversine(double lat1, lon1, lat2, lon2) {
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
      getposevery5sec!.cancel();
    }
    setState(() => timer?.cancel());
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Position? _getCurrentLocation(List<Position> positionlist) {
    getposevery5sec = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        ).then((Position position) {
          print(position);
          pos.add(position);
          Position prima = pos[0];
          for (int i = 0; i < pos.length - 1; i++) {
            if (timerinteractions >= 1) {
              somma += haversine(
                pos[0].latitude,
                pos[0].longitude,
                pos[pos.length - 1].latitude,
                pos[pos.length - 1].longitude,
              );

              pos.removeAt(0);
            }
          }
          timerinteractions++;

          distanza = somma.toStringAsFixed(2);
          return somma -
              0.015; //gps ha argine di errore di circa 15 metri in campo aperto
        }).catchError((e) {
          return somma;
        });
      } on LocationServiceDisabledException {
        bool openpage = await Geolocator.openLocationSettings();
        if (openpage) {
          //await Geolocator.openAppSettings();
        }
      }
    });
    return null;
  }
}
