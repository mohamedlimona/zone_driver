import 'package:zonedriver/models/user_model.dart';

abstract class DriverInfoState {}

class DriverInfoInitial extends DriverInfoState {}

class DriverInfoloading extends DriverInfoState {}

class DriverInfoloaded extends DriverInfoState {
  Usermodel? response;
  DriverInfoloaded(this.response);
}

class DriverInfoerorr extends DriverInfoState {}
