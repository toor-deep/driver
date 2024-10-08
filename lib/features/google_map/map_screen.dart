import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final LatLng currentLocation;

  const MapSample({super.key, required this.currentLocation});

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;


  @override
  void didUpdateWidget(covariant MapSample oldWidget) {
    mapController
        .animateCamera(CameraUpdate.newLatLng(widget.currentLocation))
        .then((value) {
      setState(() {});
    });
      super.didUpdateWidget(oldWidget);
  }



  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid && state == AppLifecycleState.resumed) {
      setState(() {
        forceReRender();
      });
    }
    //super.didChangeAppLifecycleState(state);
  }

  Future<void> forceReRender() async {
    await mapController?.setMapStyle('[]');
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        _moveCameraToCurrentLocation();
      },
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation,
        zoom: 4.0,
      ),
      markers: _createMarker(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  void _moveCameraToCurrentLocation() {
    mapController.moveCamera(CameraUpdate.newLatLng(widget.currentLocation));
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: MarkerId('currentLocation'),
        position: widget.currentLocation,
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
  }
}
