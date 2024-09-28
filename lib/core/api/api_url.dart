import 'package:cloud_firestore/cloud_firestore.dart';

class ApiUrl {
  const ApiUrl._();

  static const baseUrl = "https://....com/api/v1";


  static final users = FirebaseFirestore.instance.collection("users");
  static final requested_rides =
      FirebaseFirestore.instance.collection('requested_rides');
  static final prebook_rides =
  FirebaseFirestore.instance.collection('prebook_rides');
}
