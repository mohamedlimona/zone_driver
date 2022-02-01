import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zonedriver/models/user_model.dart';
import '../../repositories/auth.dart';
import 'driverinfo_state.dart';

class DriverInfoCubit extends Cubit<DriverInfoState> {
  DriverInfoCubit() : super(DriverInfoInitial());
  AuthRepo auth = AuthRepo();
  Usermodel? DriverInfo({String? phone, String? pass, BuildContext? context,required bool remember}) {
    try {
      emit(DriverInfoloading());
      // auth.DriverInfo(phone: phone, pass: pass,rememberme: remember).then((value) {
      //   if (value != null) {
      //     emit(DriverInfoloaded(value));
      //     MyApplication.navigateToReplace(context!, HomeScreen());
      //   } else {
      //     emit(DriverInfoerorr());
      //   }
      // });
    } catch (e) {
      emit(DriverInfoerorr());
    }
  }
}
