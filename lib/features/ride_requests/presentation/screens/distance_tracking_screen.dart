import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/usecase/update_ride_status.usecase.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/screens/ride_complete_dialog.dart';

import '../../../../shared/constants.dart'; // Assuming you have your map key here

class DistanceTrackingScreen extends StatefulWidget {
  final String? requestId;


  const DistanceTrackingScreen({super.key, this.requestId,});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<DistanceTrackingScreen> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Location location = Location();

  final double _destLatitude = 30.3470, _destLongitude = 76.3961;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      if (currentLocation != null) {
        // Add a marker for the current location
        _addMarker(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          "currentLocation",
          BitmapDescriptor.defaultMarker, // Custom marker or default
        );

        // Add marker for the destination
        _addMarker(
          LatLng(_destLatitude, _destLongitude),
          "destination",
          BitmapDescriptor.defaultMarkerWithHue(90),
        );

        // Adjust camera to include both markers
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            (currentLocation!.latitude! <= _destLatitude)
                ? currentLocation!.latitude!
                : _destLatitude,
            (currentLocation!.longitude! <= _destLongitude)
                ? currentLocation!.longitude!
                : _destLongitude,
          ),
          northeast: LatLng(
            (currentLocation!.latitude! > _destLatitude)
                ? currentLocation!.latitude!
                : _destLatitude,
            (currentLocation!.longitude! > _destLongitude)
                ? currentLocation!.longitude!
                : _destLongitude,
          ),
        );
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100), // Padding of 100
        );

        // Fetch and display the polyline
        await _getPolyline();
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RideCubit, RequestedRideState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(30.3564, 76.3647),
                    zoom: 4.0,
                  ),
                  myLocationEnabled: false,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(markers.values),
                  polylines: Set<Polyline>.of(polyLines.values),
                ),
                if (state.isLoading == true) ...[
                  const CircularProgressIndicator()
                ] else ...[
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: SizedBox(
                      width: 0.8.sw,
                      height: 0.07.sh,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<RideCubit>().updateRideStatus(
                              UpdateRideRequestStatusParams(
                                  requestId: widget.requestId ?? "",
                                  status: 'completed'), () {
                                context.read<RideCubit>().completeRide( widget.requestId??"");
                            showRideCompletedDialog(context);
                          });
                        },
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    markers[markerId] = marker;
    setState(() {}); // Ensure the UI updates
  }

  _addPolyLine() {
    if (polylineCoordinates.isNotEmpty) {
      PolylineId id = const PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        width: 5,
        points: polylineCoordinates,
      );
      polyLines[id] = polyline;
      setState(() {}); // Update the map with the new polyline
    } else {
      print('No polyline coordinates to add.');
    }
  }

  _getPolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: mapKey,
        request: PolylineRequest(
          origin: PointLatLng(
              currentLocation!.latitude!, currentLocation!.longitude!),
          destination: PointLatLng(_destLatitude, _destLongitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _addPolyLine();
      } else {
        print('No points found in the polyline result.');
      }
    } catch (e) {
      print('Error fetching polyline: $e');
    }
  }
}
