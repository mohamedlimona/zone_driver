import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:zonedriver/cubit/verification_cubit/verification_state.dart';
import 'package:zonedriver/helpers/utils/myApplication.dart';
import 'package:zonedriver/models/verification_model.dart';

import 'package:zonedriver/repositories/auth.dart';
import 'package:zonedriver/screens/create_new_pass_screen.dart';
import 'package:zonedriver/screens/sign_up_data_screen.dart';

class VerificationCubit extends Cubit<VerificationState> {
  static BuildContext? context;
  VerificationResponse? response;
  static String? code;
  static String? type;

  static String? phone;

  VerificationCubit() : super(VerificationInitial());
  AuthRepo authRepo = AuthRepo();
  Verification() {
    try {
      emit(VerificationLoading());
      authRepo.verify(phone!, code!).then((value) {
        if (value != null) {
          response = value;
          if (type != 'signup') {
            MyApplication.navigateTo(
                context!,
                const CreateNewPassScreen(
                  token: '',
                ));
          } else {
            MyApplication.navigateTo(context!, const SignUpScreenData());
          }
          emit(VerificationLoaded(response!));
        } else {
          emit(VerificationError());
        }
      });
      return response;
    } catch (e) {
      emit(VerificationError());
    }
  }
}
