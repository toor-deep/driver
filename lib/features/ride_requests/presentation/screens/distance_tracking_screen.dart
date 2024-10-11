import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/screens/ride_complete_dialog.dart';
import 'package:rickshaw_driver_app/shared/toast_alert.dart';
import 'package:text_scroll/text_scroll.dart';

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
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(30.3470, 76.3961),
    zoom: 12.5,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  List<LatLng> latLen = [
    const LatLng(30.3470, 76.3961),
    const LatLng(30.3564, 76.3647),
  ];

  bool _isRideCompleted = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _polyline.add(
        Polyline(
          polylineId: PolylineId('1'),
          width: 4,
          points: latLen,
          color: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  GoogleMap(
                    initialCameraPosition: _kGoogle,
                    mapType: MapType.normal,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    polylines: _polyline,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
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
