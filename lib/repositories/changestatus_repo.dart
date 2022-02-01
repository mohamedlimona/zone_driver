import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:zone_driver/app/constants.dart';
import 'package:zone_driver/helpers/utils/sharedPreferenceClass.dart';

class ChangestatusRepo {
  Future<bool?> Changestatus({String? status_id, String? order_id}) async {
    try {
      var response = await http.put(
        Uri.parse(
            'https://restaurant-test.lun.sa/api/orders/${order_id!}?api_token=${sharedPrefs.token}&order_status_id=${status_id!}&note'),
        headers: {'Accept': 'application/json'},
      );
      Map<String, dynamic> responsemap = json.decode(response.body);
      if (response.statusCode == 200 && responsemap["success"] == true) {
        return true;
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
    } on Error catch (e) {
      print('General Error: $e');
    }
  }
}
