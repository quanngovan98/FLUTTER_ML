import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ml_ki_example/FaceDetectionView.dart';
import 'package:flutter_ml_ki_example/HomeView.dart';
import 'package:flutter_ml_ki_example/ObjecDetectionView.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final Map args = settings.arguments;
  switch (settings.name) {
    case Routes.FaceDetection:
      return MaterialPageRoute(builder: (context) => FaceDetectionView());
    case Routes.Home:
      return MaterialPageRoute(builder: (context) => HomeView());
    case Routes.ObjectDetection:
      return MaterialPageRoute(builder: (context) => ObjectDetectionView());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}

class Routes {
  static const String FaceDetection = 'FaceDetection';
  static const String Home = 'Home';
  static const String ObjectDetection = 'ObjectDetection';
}
