// ignore_for_file: use_key_in_widget_constructors, file_names
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zone_driver/app/constants.dart';
import 'package:zone_driver/app/map_utils.dart';
import 'package:zone_driver/cubit/changestatus_cubit/changestatus_cubit.dart';
import 'package:zone_driver/cubit/changestatus_cubit/changestatus_state.dart';
import 'package:zone_driver/cubit/trackdeatils_cuibt/orderdetails_cubit.dart';
import 'package:zone_driver/cubit/trackdeatils_cuibt/orderdetails_state.dart';
import 'package:zone_driver/helpers/utils/myApplication.dart';
import 'package:zone_driver/repositories/map_repo.dart';
import 'package:zone_driver/repositories/update_location.dart';
import 'package:location/location.dart';
import 'package:zone_driver/screens/unAssigned_orders_screen.dart';
import 'package:zone_driver/widgets/custom_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng destinationLatLng = const LatLng(31.094254, 30.739935);
  final Set<Polyline> _polyline = {};
  Set<Marker> _markers = <Marker>{};
  Location location = Location();
  MapServices api = MapServices();
  String? distance;
  String? duration;
  bool? _serviceEnabled;
  StreamSubscription<LocationData>? _locationSubscription;
  PermissionStatus? _permissionGranted;
  _setPolyLine({LatLng? initialLatLng}) async {
    await api.getRoute(initialLatLng!, destinationLatLng).then((value) {
      if (value!.data["routes"] != []) {
        final route = value.data["routes"][0]["overview_polyline"]["points"];
        _polyline.add(Polyline(
            polylineId: const PolylineId("tripRoute"),
            width: 3,
            geodesic: true,
            points: MapUtils.convertToLatLng(MapUtils.decodePoly(route)),
            color: Theme.of(context).primaryColor));
      }
    });
  }

  UpdateLocationRepo updateLocationRepo = UpdateLocationRepo();

  getlocation() async {
    _serviceEnabled = await location.serviceEnabled();

    if (_serviceEnabled!) {
      _permissionGranted = await location.hasPermission();
      if (_serviceEnabled =
          true && _permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_serviceEnabled =
            true && _permissionGranted == PermissionStatus.granted) {
          getdata();
        } else {
          getlocation();
        }
      } else if (_serviceEnabled =
          true && _permissionGranted == PermissionStatus.granted) {
        getdata();
      }
    } else {
      _serviceEnabled = await location.requestService();
      getlocation();
    }
  }

  int firsttime = 1;
  getdata() {
    BlocProvider.of<TrackingCubit>(context).getTracking();
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        Fluttertoast.showToast(
            msg: "Please allow location for app",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 3,
            backgroundColor: Constants.primaryAppColor,
            textColor: Constants.whiteAppColor,
            fontSize: 16.0);
      }
      _locationSubscription?.cancel();
    }).listen((event) async {
      if (BlocProvider.of<TrackingCubit>(context).response != null) {
        destinationLatLng = LatLng(
            BlocProvider.of<TrackingCubit>(context).response!.data.userLatitude,
            BlocProvider.of<TrackingCubit>(context)
                .response!
                .data
                .userLongitude);
        if (firsttime == 1) {
          await api.addPolyLines(
              controlle: _controller,
              destinationLatLng: destinationLatLng,
              initial: event);

          await _setPolyLine(
              initialLatLng: LatLng(event.latitude!, event.longitude!));

          firsttime = 2;
        }
        await api.setMapPins(
            [LatLng(event.latitude!, event.longitude!), destinationLatLng],
            context).then((value) {
          _markers = value;
        });
        await api
            .gettimebetween(
                l1: LatLng(event.latitude!, event.longitude!),
                l2: destinationLatLng)
            .then((value) {
          distance = value!.rows[0].elements[0].distance.text;
          duration = value.rows[0].elements[0].duration.text;
        });
        await updateLocationRepo.updatelocation(
            latitude: event.latitude, longitude: event.longitude);
      }
      newLocationUpdate(LatLng(event.latitude!, event.longitude!));

          // setState(() {});
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    MyApplication.checkConnection().then((value) {
      if (!value) {
        Fluttertoast.showToast(
            msg: 'No Internet Connection',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        getlocation();
      }
    });
  }

  void newLocationUpdate(LatLng latLng) {
    Marker marker = RippleMarker(
      draggable: true,
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      ripple: true,
    );
    setState(() {
      for (var element in _markers) {
        if (element.markerId == MarkerId(latLng.toString())) {
          element = marker;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Animarker(
              duration: const Duration(milliseconds: 20),
              rippleDuration: const Duration(milliseconds: 20),
              mapId: _controller.future.then<int>((value) => value.mapId),
              child: GoogleMap(
                compassEnabled: true,
                mapType: MapType.normal,
                rotateGesturesEnabled: true,
                zoomGesturesEnabled: true,
                trafficEnabled: false,
                tiltGesturesEnabled: false,
                scrollGesturesEnabled: true,
                markers: _markers,
                polylines: _polyline,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: BlocListener(
                bloc: BlocProvider.of<TrackingCubit>(context),
                listener: (BuildContext context, state) {
                  if (state is TrackingLoaded) {
                    if (state.response!.data.orderStatusId == 5) {
                      MyApplication.navigateToReplace(
                          context, UnAssignedOrdersScreen());
                    }
                  }
                },
                child: BlocBuilder<TrackingCubit, TrackingState>(
                    bloc: BlocProvider.of<TrackingCubit>(context),
                    builder: (context, state) {
                      if (state is TrackingLoading) {
                        return SpinKitThreeBounce(
                          color: Constants.primaryAppColor,
                          size: size.width * .08,
                        );
                      } else if (state is TrackingLoaded) {
                        destinationLatLng ==
                            LatLng(state.response!.data.userLatitude,
                                state.response!.data.userLongitude);

                        return Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10.0, right: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5)),
                                child: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                        'assets/images/profile.jpg')),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                width: size.width,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF444D50),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60.0),
                                    topRight: Radius.circular(60.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10.0, right: 8.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFE44544),
                                                        width: 1.5)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: state.response!
                                                            .data.user.hasMedia
                                                        ? state.response!.data
                                                            .user.media[0].thumb
                                                        : 'ff',
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.fitWidth,
                                                    placeholder:
                                                        (context, str) {
                                                      return const SpinKitThreeBounce(
                                                        color: Constants
                                                            .primaryAppColor,
                                                        size: 10,
                                                      );
                                                    },
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "assets/images/no_image.jpg",
                                                      width: size.width,
                                                      height: 250,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      state.response!.data.user
                                                          .name,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                  const SizedBox(height: 1),
                                                  RatingBar.builder(
                                                    itemSize: 10,
                                                    initialRating: state
                                                        .response!.data.userRate
                                                        .toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    unratedColor: Colors.grey,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/images/detail.svg",
                                                  width: 25,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: size.width * .05,
                                              ),
                                              SvgPicture.asset(
                                                  "assets/images/chat.svg",
                                                  width: 20,
                                                  color: Colors.white),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(60.0),
                                          topRight: Radius.circular(60.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/images/money.svg",
                                                        width: 25,
                                                        color: const Color(
                                                            0xFF43494B)),
                                                    const SizedBox(width: 10),
                                                    const Text("Total order",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF43494B)))
                                                  ],
                                                ),
                                                Text(
                                                    state.response!.data
                                                            .totalPayment
                                                            .toString() +
                                                        " SAR",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFFE44544)))
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/images/time.svg",
                                                        width: 25,
                                                        color: const Color(
                                                            0xFF43494B)),
                                                    const SizedBox(width: 10),
                                                    const Text("Delivery time",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF43494B)))
                                                  ],
                                                ),
                                                Text(
                                                    duration == null
                                                        ? "0"
                                                        : duration!,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFFE44544)))
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/images/navi.svg",
                                                        width: 25,
                                                        color: const Color(
                                                            0xFF43494B)),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                        "Distance from you",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF43494B)))
                                                  ],
                                                ),
                                                Text(
                                                    distance == null
                                                        ? "0"
                                                        : distance!,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFFE44544)))
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/images/money.svg",
                                                        width: 25,
                                                        color: const Color(
                                                            0xFF43494B)),
                                                    const SizedBox(width: 10),
                                                    const Text("Payment Method",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF43494B)))
                                                  ],
                                                ),
                                                Text(
                                                    state.response!.data
                                                        .paymentMethod,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFFE44544)))
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                BlocBuilder<ChangestatusCubit,
                                                        ChangestatusState>(
                                                    builder:
                                                        (context, statestatus) {
                                                  if (statestatus
                                                      is ChangestatusLoading) {
                                                    return SpinKitThreeBounce(
                                                      color: Constants
                                                          .primaryAppColor,
                                                      size: size.width * .08,
                                                    );
                                                  } else if (statestatus
                                                      is ChangestatusLoaded) {
                                                    return InkWell(
                                                      onTap: () {
                                                        state.response!.data
                                                                    .orderStatusId ==
                                                                3
                                                            ? BlocProvider.of<
                                                                        ChangestatusCubit>(
                                                                    context)
                                                                .getChangestatus(
                                                                    status_id:
                                                                        "4",
                                                                    order_id: state
                                                                        .response!
                                                                        .data
                                                                        .id
                                                                        .toString())
                                                            : BlocProvider.of<
                                                                        ChangestatusCubit>(
                                                                    context)
                                                                .getChangestatus(
                                                                    status_id:
                                                                        "5",
                                                                    order_id: state
                                                                        .response!
                                                                        .data
                                                                        .id
                                                                        .toString());

                                                        BlocProvider.of<
                                                                    TrackingCubit>(
                                                                context)
                                                            .getTracking();
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: size.width * .5 -
                                                            60,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xFF80AF50),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24.0)),
                                                        child: Text(
                                                          state.response!.data
                                                                      .orderStatusId ==
                                                                  3
                                                              ? "Pickup"
                                                              : "delivered",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return InkWell(
                                                      onTap: () {
                                                        state.response!.data
                                                                    .orderStatusId ==
                                                                3
                                                            ? BlocProvider.of<
                                                                        ChangestatusCubit>(
                                                                    context)
                                                                .getChangestatus(
                                                                    status_id:
                                                                        "4",
                                                                    order_id: state
                                                                        .response!
                                                                        .data
                                                                        .id
                                                                        .toString())
                                                            : BlocProvider.of<
                                                                        ChangestatusCubit>(
                                                                    context)
                                                                .getChangestatus(
                                                                    status_id:
                                                                        "5",
                                                                    order_id: state
                                                                        .response!
                                                                        .data
                                                                        .id
                                                                        .toString());

                                                        BlocProvider.of<
                                                                    TrackingCubit>(
                                                                context)
                                                            .getTracking();
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: size.width * .5 -
                                                            60,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xFF80AF50),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24.0)),
                                                        child: Text(
                                                          state.response!.data
                                                                      .orderStatusId ==
                                                                  3
                                                              ? "Pickup"
                                                              : "delivered",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CustomAlert();
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: size.width * .5 - 60,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFE44544),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    24.0)),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Center(child: Text("no orders yet"));
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
