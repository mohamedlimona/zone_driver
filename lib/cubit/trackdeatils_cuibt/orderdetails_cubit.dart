import 'package:bloc/bloc.dart';
import 'package:zone_driver/cubit/trackdeatils_cuibt/orderdetails_state.dart';
import 'package:zone_driver/models/tracking_model.dart';
import 'package:zone_driver/repositories/Tracking.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(TrackingInitial());
  TrackingRepo Tracking = TrackingRepo();
  Trackingmodel? response;
  Trackingmodel? getTracking() {
    try {
      emit(TrackingLoading());
      Tracking.getOrderDetails().then((value) {
        if (value != null) {
          response=value;
          emit(TrackingLoaded(value));
        } else {
          emit(TrackingErorr());
        }
      });
    } catch (e) {
      emit(TrackingErorr());
    }
  }
}
