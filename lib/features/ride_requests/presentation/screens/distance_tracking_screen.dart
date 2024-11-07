import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rickshaw_driver_app/features/google_map/bloc/location_state.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/screens/ride_complete_dialog.dart';
import 'package:rickshaw_driver_app/shared/toast_alert.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../google_map/bloc/location_cubit.dart';
import '../../../google_map/map_screen.dart';
import '../../domain/usecase/update_ride_status.usecase.dart';
import '../bloc/ride_request_bloc.dart';

class DistanceTrackingScreen extends StatefulWidget {
  final String requestId;

  const DistanceTrackingScreen({required this.requestId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DistanceTrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng currentPosition;

  bool _isRideCompleted = false;

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit,LocationState>(
      builder: (context, locationState) {
        if (locationState.position != null) {
          currentPosition = LatLng(locationState.position!.latitude,
              locationState.position!.longitude);
        } else {
          currentPosition = const LatLng(37.7749, -122.4194);
        }
        return BlocBuilder<RideCubit, RequestedRideState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (_isRideCompleted) {
                  Navigator.pop(context);
                } else {
                  showSnackbar(
                      'You have to complete ride before proceeding', Colors.red);
                }
              },
              child: Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      MapSample(
                        currentLocation: currentPosition,
                      ),
                      if (state.isLoading == true)
                        const Center(child: CircularProgressIndicator()),
                      Container(
                        height: 0.04.sh,
                        color: Colors.white,
                        child: const Center(
                          child: TextScroll(
                            delayBefore: Duration(milliseconds: 1000),
                            " Note:- Please complete the ride only after the user has made the payment.",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (state.isLoading == false) // Show button when not loading
                        Positioned(
                          bottom: 30,
                          left: 20,
                          child: SizedBox(
                            width: 0.8.sw,
                            height: 0.07.sh,
                            child: ElevatedButton(
                              onPressed: _isRideCompleted
                                  ? () => Navigator.pop(context)
                                  : _onDelivered,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Delivered"),
                                  Icon(Icons.send, size: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },

    );
  }

  void _onDelivered() {
    context.read<RideCubit>().updateRideStatus(
      UpdateRideRequestStatusParams(
        requestId: widget.requestId,
        status: 'completed',
        driverId: FirebaseAuth.instance.currentUser?.uid ?? "",
      ),
      () {
        setState(() {
          _isRideCompleted = true;
        });
        context.read<RideCubit>().completeRide(widget.requestId,'completed', () {
          showRideCompletedDialog(context);
        });
      },
    );
  }
}
