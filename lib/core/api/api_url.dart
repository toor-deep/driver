import 'package:cloud_firestore/cloud_firestore.dart';

class ApiUrl {
  const ApiUrl._();

  static final users = FirebaseFirestore.instance.collection("users");
  static final requestedRides =
      FirebaseFirestore.instance.collection('requested_rides');
  static final prebook_rides =
      FirebaseFirestore.instance.collection('prebook_rides');
  static final rides = FirebaseFirestore.instance.collectionGroup('rides');
}
