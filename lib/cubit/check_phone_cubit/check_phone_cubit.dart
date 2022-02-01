import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:zonedriver/helpers/utils/myApplication.dart';
import 'package:zonedriver/models/check_phone_model.dart';
import 'package:zonedriver/repositories/auth.dart';
import 'package:zonedriver/screens/verify_code_screen.dart';

import 'check_phone_state.dart';



class CheckPhoneCubit extends Cubit<CheckPhoneState> {


  CheckPhoneCubit() : super(CheckPhoneInitial());
  AuthRepo authRepo = AuthRepo();
  CheckPhone({ BuildContext? context,
  CheckPhoneResponse? response,
   String? phone,String? widgetType}) {
    try {
      emit(CheckPhoneLoading());
      authRepo.checkPhone(phone!).then((value) {
        if (value != null) {
          response = value;
          emit(CheckPhoneLoaded(response!));
          MyApplication.navigateTo(context!, VerifyCodeScreen(phone,widgetType!));
        } else {
          emit(CheckPhoneError());
        }
      });
      return response;
    } catch (e) {
      emit(CheckPhoneError());
    }
  }
}
