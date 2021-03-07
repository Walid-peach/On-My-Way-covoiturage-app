import 'dart:async';
import 'dart:io';

import 'package:covoiturage_app/contollers/UserController.dart';
import 'package:covoiturage_app/screens/Home.dart';
import 'package:covoiturage_app/screens/SignIn.dart';
import 'package:covoiturage_app/widgets/animatedRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  BoxFit logo = BoxFit.contain;
  Timer _timer;
  bool login = false;
  UserController userController = new UserController();
  var currentOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    checkLogin();
    startAnimation();
  }

  void checkLogin() async {
    await userController.isLogin().then((value) => this.setState(() => {
          login = value,
          print("value $value"),
          print("isLogin $login"),
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  startAnimation() async {
    const oneSec = const Duration(seconds: 1);
    var start = 8;
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
        this.setState(() {
          currentOpacity += 0.1;
        });
      }
      if (start == 0) {
        sleep(Duration(seconds: 3));
        login == true ? goToHomePage() : goToLoginPage();
      }
      start -= 1;
    });
  }

  void goToLoginPage() {
    Navigator.pushReplacement(context, SlideRightRoute(page: SignIn()));
  }

  void goToHomePage() {
    Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
  }

  @override
  Widget build(cnx) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(color: Colors.white10),
        child: Center(
          child: Opacity(
            opacity: currentOpacity,
            child: new Container(
              width: MediaQuery.of(context).size.width / 2,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new ExactAssetImage('assets/images/logoonmyway.png',
                      scale: 0.5),
                  fit: logo,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
