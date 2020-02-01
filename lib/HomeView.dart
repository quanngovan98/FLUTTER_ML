import 'package:flutter/material.dart';
import 'package:flutter_ml_ki_example/services/navigationService.dart';
import 'package:flutter_ml_ki_example/services/router.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ML kit"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tooltip(
              message: "Face Detection",
              child: InkWell(
                onTap: () {
                  navigatorKey.currentState.pushNamed(Routes.FaceDetection);
                },
                child: Icon(
                  Icons.face,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
            ),
            Tooltip(
              message: "Object Detection",
              child: InkWell(
                onTap: () {
                  navigatorKey.currentState.pushNamed(Routes.ObjectDetection);
                },
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
