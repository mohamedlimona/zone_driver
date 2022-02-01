import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zone_driver/cubit/signup_cubit/signup_state.dart';
import 'package:zone_driver/models/signup_model.dart';
import 'package:zone_driver/repositories/auth.dart';


class SignUpCubit extends Cubit<SignUpState> {
  static BuildContext? context;
  SignUpResponse? response;
  SignUpCubit() : super(SignUpInitial());
  AuthRepo authRepo = AuthRepo();
  signUp(String name, String phone,
      String password, String passwordConfirmation,String idFrontImage
      ,String idBackImage ,String driverFrontImage
      ,String driverBackImage ,String vehicleFrontImage
      ,String vehicleBackImage) {
    try {
      emit(SignUpLoading());
      authRepo
          .signUp(name,  phone, password, passwordConfirmation, idFrontImage, idBackImage, driverFrontImage, driverBackImage, vehicleFrontImage, vehicleBackImage,context!)
          .then((value) {
        emit(SignUpLoaded());
 
      });
      return response;
    } catch (e) {
      emit(SignUpError());
    }
  }
}
