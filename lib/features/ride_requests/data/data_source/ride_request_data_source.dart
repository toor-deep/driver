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

  Future<List<RideRequest>> getCompletedRideRequestsForDriver(String driverId);

  Future<RideRequest> getRideRequestDetails(String requestId);

  Future<void> saveCompletedOrCanceledRide({
    required String driverId,
    required String requestId,
  });
}

class DriverRideRequestDataSourceImpl implements DriverRideRequestDataSource {
  @override
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final updateData = {'status': status};
      final querySnapshot =
          await ApiUrl.rides.where('id', isEqualTo: requestId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        await doc.reference.update(updateData);
      } else {
        throw Exception('Ride request not found.');
      }
    } catch (e) {
      throw Exception('Failed to update ride request status: $e');
    }
  }

  @override
  Stream<List<RideRequest>> getAllPendingRideRequestsForDriver() {
    return ApiUrl.rides
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return RideRequest.fromMap(doc.data());
      }).toList();
    }).handleError((error) {
      print('Error fetching pending ride requests: $error');
    });
  }

  @override
  Future<RideRequest> getRideRequestDetails(String requestId) async {
    try {
      final querySnapshot =
          await ApiUrl.rides.where('id', isEqualTo: requestId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();

        return RideRequest.fromMap(data);
      } else {
        throw Exception('Ride request not found.');
      }
    } catch (e) {
      throw Exception('Failed to get ride request details: $e');
    }
  }

  @override
  Future<void> saveCompletedOrCanceledRide({
    required String driverId,
    required String requestId,
  }) async {
    try {
      final rideRequest = await getRideRequestDetails(requestId);

      final completedRidesRef =
          ApiUrl.driverRides.doc(driverId).collection('rides').doc();

      final rideRequestModel = RideRequest(
        id: completedRidesRef.id,
        userId: rideRequest.userId,
        preBookRideTime: rideRequest.preBookRideTime,
        preBookRideDate: rideRequest.preBookRideDate,
        isScheduled: rideRequest.isScheduled,
        userName: rideRequest.userName,
        startLocation: rideRequest.startLocation,
        endLocation: rideRequest.endLocation,
        vehicleType: rideRequest.vehicleType,
        price: rideRequest.price,
        status: rideRequest.status,
        createdAt: DateTime.now(),
      );

      await completedRidesRef.set(rideRequestModel.toMap());
    } catch (e) {
      throw Exception('Failed to save completed ride: $e');
    }
  }

  @override
  Future<List<RideRequest>> getCompletedRideRequestsForDriver(
      String driverId) async {
    try {
      final querySnapshot =
          await ApiUrl.driverRides.doc(driverId).collection('rides').get();

      final completedRides = querySnapshot.docs.map((doc) {
        return RideRequest.fromMap(doc.data());
      }).toList();

      return completedRides;
    } catch (e) {
      throw Exception('Failed to fetch completed ride requests: $e');
    }
  }
}
