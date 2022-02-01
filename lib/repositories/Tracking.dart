// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:zonedriver/app/constants.dart';
import 'package:zonedriver/helpers/utils/sharedPreferenceClass.dart';
import 'package:zonedriver/models/tracking_model.dart';

class TrackingRepo {
  Future<Trackingmodel?> getOrderDetails() async {
    try {
      print(sharedPrefs.token);
      var response = await http.get(
        Uri.parse(
            'https://restaurant-test.lun.sa/api/tracking/0?api_token=${sharedPrefs.token}'),
        headers: {'Accept': 'application/json'},
      );
      print(sharedPrefs.token);
      Map<String, dynamic> responsemap = json.decode(response.body);
      if (response.statusCode == 200 && responsemap["success"] == true) {
        final data = Trackingmodel.fromJson(jsonDecode(response.body));
        return data;
      } else {
        Fluttertoast.showToast(
            msg: responsemap["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 3,
            backgroundColor: Constants.primaryAppColor,
            textColor: Constants.whiteAppColor,
            fontSize: 16.0);
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    }
  }
}
