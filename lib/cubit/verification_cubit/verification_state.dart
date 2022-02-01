import 'package:zonedriver/models/verification_model.dart';

abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationLoaded extends VerificationState {
  VerificationResponse verificationResponse;
  VerificationLoaded(this.verificationResponse);
}

class VerificationError extends VerificationState {}
