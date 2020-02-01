import 'package:flutter/material.dart';
import 'package:flutter_ml_ki_example/services/navigationService.dart';
import 'package:flutter_ml_ki_example/services/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: generateRoute,
        navigatorKey: navigatorKey,
        initialRoute: Routes.Home);
  }
}
