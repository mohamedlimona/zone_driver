// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:zonedriver/app/constants.dart';
import 'package:zonedriver/widgets/global_appbar_widget.dart';

class PendingScreen extends StatefulWidget {
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.primaryAppColor,
      appBar: GlobalAppBar(
        color: Constants.whiteAppColor,
        enableBackButton: false,
        height: size.height * 0.4,
        child: SvgPicture.asset("assets/images/logo.svg",
            color: Constants.primaryAppColor, height: size.height * 0.22),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(30),
        child: Column(
          children: [
            SizedBox(
                height: size.height * 0.15,
                width: size.width * 0.3,
                child: Lottie.asset("assets/images/loading.json")),
            SizedBox(height: size.height * 0.07),
            const Text("Thank You",
                style: TextStyle(color: Constants.whiteAppColor, fontSize: 35)),
            SizedBox(height: size.height * 0.01),
            const Center(
              child: Text("Your request is pending\nto approve!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constants.whiteAppColor,
                      fontSize: 25,
                      height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
