// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:zone_driver/app/constants.dart';
import 'package:zone_driver/helpers/utils/myApplication.dart';
import 'package:zone_driver/helpers/utils/sharedPreferenceClass.dart';
import 'package:zone_driver/screens/home_screen.dart';
import 'package:zone_driver/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
     sharedPrefs.getSignedIn()?MyApplication.navigateToReplace(context, HomeScreen()):MyApplication.navigateToReplace(context, WelcomeScreen());

    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(top: size.height * 0.14),
        color: Constants.primaryAppColor,
        child: Column(
          children: [
            SvgPicture.asset("assets/images/logo.svg"),
            SizedBox(height: size.height * 0.05),
            const Text(
              "Welcome to the\nDriver app",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Constants.whiteAppColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: size.height * 0.03),
            Lottie.asset(
              'assets/images/loc.json',
              width: size.width * 0.6,
              height: size.height * 0.25,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
