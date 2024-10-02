
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceTrackingScreen extends StatefulWidget {
  const DistanceTrackingScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<DistanceTrackingScreen> {
  late GoogleMapController mapController;
  final double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  final double _destLatitude = 6.849660, _destLongitude = 3.648190;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "Please provide your api key";

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(_originLatitude, _originLongitude), zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polyLines.values),
      )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polyLines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleAPiKey,
      request: PolylineRequest(
        origin: PointLatLng(_originLatitude, _originLongitude),
        destination: PointLatLng(_destLatitude, _destLongitude),
        mode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }
}
