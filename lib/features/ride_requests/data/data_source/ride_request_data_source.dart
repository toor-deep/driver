import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';

import '../../../../core/api/api_url.dart';
import '../model/ride_request_model.dart';

abstract class DriverRideRequestDataSource {
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
  });

  Stream<List<RideRequest>> getAllPendingRideRequestsForDriver();

  Future<RideRequest> getRideRequestDetails(String requestId);
}

class DriverRideRequestDataSourceImpl implements DriverRideRequestDataSource {
  @override
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final updateData = {'status': status};
      await ApiUrl.requestedRides.doc(requestId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update ride request status: $e');
    }
  }

  @override
  Stream<List<RideRequest>> getAllPendingRideRequestsForDriver() {
    return FirebaseFirestore.instance
        .collectionGroup('rides')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((querySnapshot) {

      return querySnapshot.docs.map((doc) {
        print( RideRequest.fromMap(doc.data()));
        return RideRequest.fromMap(doc.data());
      }).toList();
    });
  }


  @override
  Future<RideRequest> getRideRequestDetails(String requestId) async {
    try {
      final doc = await ApiUrl.requestedRides.doc(requestId).get();

      if (doc.exists) {
        return RideRequest.fromMap(doc.data()!);
      } else {
        throw Exception('Ride request not found');
      }
    } catch (e) {
      throw Exception('Failed to get ride request details: $e');
    }
  }
}
