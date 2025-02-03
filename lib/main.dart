import 'package:flight_tracker/screens/get_started.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flight Tracker',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: GetStarted(),
    debugShowCheckedModeBanner: false,
  );
}
}