import '../../../../core/api/api_url.dart';
import '../model/ride_request_model.dart';

abstract class DriverRideRequestDataSource {
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
  });

  Future<List<RideRequest>> getAllPendingRideRequestsForDriver();

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
      await ApiUrl.requested_rides.doc(requestId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update ride request status: $e');
    }
  }

  @override
  Future<List<RideRequest>> getAllPendingRideRequestsForDriver() async {
    List<RideRequest> allPendingRides = [];

    try {
      final rideRequestsSnapshot = await ApiUrl.prebook_rides.get();
      print('Total Ride Requests: ${rideRequestsSnapshot.docs.length}');

      for (var requestDoc in rideRequestsSnapshot.docs) {
        print('Accessing rides for document: ${requestDoc.id}');

        final ridesSnapshot = await requestDoc.reference
            .collection('rides')
            .get(); // Get all rides without filtering

        // Print the number of rides in the document
        print('Total Rides for ${requestDoc.id}: ${ridesSnapshot.docs.length}');

        // Filter rides for the 'pending' status
        for (var rideDoc in ridesSnapshot.docs) {
          final rideData = rideDoc.data();
          // Check if the ride has a status field
          if (rideData['status'] == 'pending') {
            allPendingRides.add(RideRequest.fromMap(rideData));
          }
        }
      }

      print('Total Pending Rides: ${allPendingRides.length}'); // Final count
      return allPendingRides;
    } catch (e) {
      throw Exception('Failed to get pending ride requests: $e');
    }
  }

  @override
  Future<RideRequest> getRideRequestDetails(String requestId) async {
    try {
      final doc = await ApiUrl.requested_rides.doc(requestId).get();

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
