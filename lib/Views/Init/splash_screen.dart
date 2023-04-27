import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shoppingcart/Controllers/Auth/BiometricsController.dart';
import 'package:shoppingcart/Controllers/Auth/LoginController.dart';
import 'package:shoppingcart/Models/DB/User.dart';
import 'package:shoppingcart/Models/Strings/splash_screen.dart';
import 'package:shoppingcart/Models/Utils/Colors.dart';
import 'package:shoppingcart/Models/Utils/Common.dart';
import 'package:shoppingcart/Models/Utils/Images.dart';
import 'package:shoppingcart/Models/Utils/Routes.dart';
import 'package:shoppingcart/Views/Auth/login.dart';
import 'package:shoppingcart/Views/Init/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  bool isTimerInitialized = false;

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    if (isTimerInitialized) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color6,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: displaySize.width * 0.5,
              child: Image.asset(logo),
            ),
          ),
          Positioned(
              bottom: 0.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(SplashScreen_bottom_text_1.toUpperCase()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      SplashScreen_bottom_text_2.toUpperCase(),
                      style: const TextStyle(fontSize: 11.0),
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }

  void startApp() async {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      isTimerInitialized = true;
      _timer.cancel();
      Routes(context: context).navigateReplace(const MainScreen());
    });
  }
}
