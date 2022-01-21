import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class WorkoutItemModel {
  String name;
  String description;
  String image;
  IconData icon;

  WorkoutItemModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.icon});
}

final List<WorkoutItemModel> workoutsItems = [
  WorkoutItemModel(
      name: 'Walk',
      description: 'All the greatest thoughts are conceived while walking.',
      image: 'assets/images/black/25.jpg',
      icon: IcoFontIcons.heartBeat),
  WorkoutItemModel(
      name: 'Run',
      description:
          'To overcome others is to have strength, to overcome yourself is to be strong.',
      image: 'assets/images/black/28.jpg',
      icon: IcoFontIcons.runnerAlt1),
  WorkoutItemModel(
      name: 'Bicycle',
      description:
          'Life is like riding a bicycle. To stay balanced, you have to move.',
      image: 'assets/images/black/26.jpg',
      icon: IcoFontIcons.cycling),
  WorkoutItemModel(
      name: 'Pull Ups',
      description: 'It is never too late to start taking care of your body.',
      image: 'assets/images/black/4.jpg',
      icon: IcoFontIcons.gym),
  WorkoutItemModel(
      name: 'Push Ups',
      description:
          'Take good care of your body, it is the only place you have to live.',
      image: 'assets/images/black/27.jpg',
      icon: IcoFontIcons.muscle),
  WorkoutItemModel(
      name: 'Squat',
      description:
          'When the heart starts pumping, imagine all that blood and oxygen rising to the brain.',
      image: 'assets/images/black/20.jpg',
      icon: IcoFontIcons.gymAlt2),
];
