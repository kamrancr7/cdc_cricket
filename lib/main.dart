import 'dart:async';

import 'package:cdc_cricket/home_screen.dart';
import 'package:cdc_cricket/match_edit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'points_table.dart';
import 'map_screen.dart';
import 'teams.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.indigo[500],
        primaryColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/points_table": (BuildContext context) => PointsTable(),
        "/map_screen": (BuildContext context) => MapScreen(),
        "/team_screen": (BuildContext context) => Teams(),
        "/match_edit": (BuildContext context) => MatchEdit(),
      }
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async {
    return new Timer(Duration(milliseconds: 3500), NavigatorPage);
  }
  // To navigate layout change
  void NavigatorPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen()));
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/splash.jpg"),
                ),
              ),
            ),
          ],
        )
    );
  }
}

