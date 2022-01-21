import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getfitappmobile/models/Works/worksmodel.dart';
import 'package:getfitappmobile/shared/styles/colors.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:intl/intl.dart';

class WorkoutDetail extends StatefulWidget {
  final Works work;
  const WorkoutDetail({Key? key, required this.work}) : super(key: key);

  @override
  _WorkoutDetailState createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThirdColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [backgroundImage(), titleSubtitle()],
            ),
            const SizedBox(
              height: 10,
            ),
            stats()
          ],
        ),
      ),
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
                const Icon(Icons.date_range),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Date',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  DateFormat.yMMMMd('en_US').format(widget.work.Date!),
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
                  'Start',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  DateFormat('kk:mm:a').format(widget.work.Start!),
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
                  'End',
                  style: TextStyle(),
                ),
                const Spacer(),
                Text(
                  DateFormat('kk:mm:a').format(widget.work.End!),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              color: kThirdColor,
              height: 25,
            ),
            widget.work.ActivityName! == 'Walk' ||
                    widget.work.ActivityName! == 'Run' ||
                    widget.work.ActivityName! == 'Bicycle'
                ? Row(
                    children: [
                      const Icon(IcoFontIcons.ruler),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        'Distance',
                        style: TextStyle(),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.work.Km} Km',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : Row(
                    children: [
                      const Icon(IcoFontIcons.ruler),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        'Repetitions',
                        style: TextStyle(),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.work.Ripetizioni} rep',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Container titleSubtitle() {
    String description;
    switch (widget.work.ActivityName!) {
      case 'Walk':
        description = 'All the greatest thoughts are conceived while walking.';
        break;
      case 'Run':
        description =
            'To overcome others is to have strength, to overcome yourself is to be strong.';
        break;
      case 'Bicycle':
        description =
            'Life is like riding a bicycle. To stay balanced, you have to move.';
        break;
      case 'Pull Ups':
        description = 'It is never too late to start taking care of your body.';
        break;
      case 'Push Ups':
        description =
            'Take good care of your body, it is the only place you have to live.';
        break;
      case 'Squat':
        description =
            'When the heart starts pumping, imagine all that blood and oxygen rising to the brain.';
        break;
      default:
        description =
            'Take good care of your body, it is the only place you have to live.';
    }
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
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        border: const Border(
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
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
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
                    widget.work.ActivityName!,
                    style: const TextStyle(
                        fontSize: 40,
                        color: kFirstColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(description, style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Hero backgroundImage() {
    String image;
    switch (widget.work.ActivityName!) {
      case 'Walk':
        image = 'assets/images/black/25.jpg';
        break;
      case 'Run':
        image = 'assets/images/black/28.jpg';
        break;
      case 'Bicycle':
        image = 'assets/images/black/26.jpg';
        break;
      case 'Pull Ups':
        image = 'assets/images/black/4.jpg';
        break;
      case 'Push Ups':
        image = 'assets/images/black/27.jpg';
        break;
      case 'Squat':
        image = 'assets/images/black/20.jpg';
        break;
      default:
        image = 'assets/images/black/25.jpg';
    }

    return Hero(
      tag: image,
      child: Container(
        height: Get.height * 0.40,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      ),
    );
  }
}
