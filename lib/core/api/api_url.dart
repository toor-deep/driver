import 'package:cloud_firestore/cloud_firestore.dart';

class ApiUrl {
  const ApiUrl._();

  static final users = FirebaseFirestore.instance.collection("users");
  static final requestedRides =
      FirebaseFirestore.instance.collection('requested_rides');
  static final driverRides =
      FirebaseFirestore.instance.collection('driver_history');
  static final prebook_rides =
      FirebaseFirestore.instance.collection('prebook_rides');
  static final rides = FirebaseFirestore.instance.collectionGroup('rides');
  static final driver_history_rides = FirebaseFirestore.instance.collectionGroup('driver_rides');
}
