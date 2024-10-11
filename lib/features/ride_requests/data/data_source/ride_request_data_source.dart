import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/api/api_url.dart';
import '../model/ride_request_model.dart';

abstract class DriverRideRequestDataSource {
  Future<void> updateRideRequestStatus(
      {required String requestId,
      required String status,
      required String driverId});

  Stream<List<RideRequest>> getAllPendingRideRequestsForDriver(String driverId);

  Future<List<RideRequest>> getCompletedRideRequestsForDriver(String driverId);

  Future<RideRequest> getRideRequestDetails(String requestId);

  Stream<List<RideRequest>> getPreBookedRidesForDriver(String driverId);

  Future<void> saveCompletedOrCanceledRide({
    required String driverId,
    required String requestId,
    required String status,
  });
}

class DriverRideRequestDataSourceImpl implements DriverRideRequestDataSource {
  @override
  Future<void> updateRideRequestStatus(
      {required String requestId,
      required String status,
      required String driverId}) async {
    try {
      final updateData = {'status': status, 'driverId': driverId};
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
  @override
  Stream<List<RideRequest>> getAllPendingRideRequestsForDriver(
      String driverId) {
    // Stream for canceled rides based on the 'id' field from the ride data
    final Stream<Set<String>> canceledRidesStream = ApiUrl.driver_history_rides
        .where('status',
            isEqualTo: 'cancelled') // Ensure status matches 'cancelled'
        .snapshots()
        .map((querySnapshot) {
      print(
          'Canceled rides for driver $driverId: ${querySnapshot.docs.length}'); // Debugging

      // Collect the 'id' field from each document as the canceled ride ID
      return querySnapshot.docs
          .map((doc) => doc.data()['id']
              as String) // Use the 'id' field from the document data
          .toSet();
    });

    // Stream for pending rides
    final Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        pendingRidesStream = ApiUrl.rides
            .where('status', isEqualTo: 'pending')
            .snapshots()
            .map((querySnapshot) => querySnapshot.docs);

    // Combine the two streams
    return Rx.combineLatest2<List<QueryDocumentSnapshot<Map<String, dynamic>>>,
        Set<String>, List<RideRequest>>(
      pendingRidesStream,
      canceledRidesStream,
      (List<QueryDocumentSnapshot<Map<String, dynamic>>> pendingDocs,
          Set<String> canceledRideIds) {
        // Filter out rides where the 'id' matches any canceled ride ID
        return pendingDocs.where((doc) {
          final rideId = doc.data()['id']
              as String; // Get 'id' field from the document data
          final isCancelled =
              canceledRideIds.contains(rideId); // Check if it's canceled
          if (isCancelled) {
            print('Excluding canceled ride ID: $rideId');
          }
          return !isCancelled; // Exclude canceled rides
        }).map((doc) {
          return RideRequest.fromMap(doc.data());
        }).toList();
      },
    ).handleError((error) {
      print('Error fetching pending ride requests: $error');
    });
  }

  Stream<List<RideRequest>> getPreBookedRidesForDriver(String driverId) {
    // Stream for canceled rides, collecting 'id' field from the document data
    final Stream<Set<String>> canceledRidesStream = ApiUrl.driver_history_rides
        .where('status', isEqualTo: 'cancelled')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => doc.data()['id'] as String)
          .toSet();
    });

    // Stream for pre-booked rides
    final Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
        preBookedRidesStream = ApiUrl.rides
            .where('isScheduled', isEqualTo: true)
            .where('status', isEqualTo: 'accepted')
            .where('driverId', isEqualTo: driverId)
            .snapshots()
            .map((querySnapshot) => querySnapshot.docs);

    // Combine the two streams
    return Rx.combineLatest2<List<QueryDocumentSnapshot<Map<String, dynamic>>>,
        Set<String>, List<RideRequest>>(
      preBookedRidesStream,
      canceledRidesStream,
      (List<QueryDocumentSnapshot<Map<String, dynamic>>> preBookedDocs,
          Set<String> canceledRideIds) {
        // Map the pre-booked rides and filter out canceled rides based on the 'id' field
        return preBookedDocs.where((doc) {
          final rideId = doc.data()['id'] as String;
          return !canceledRideIds.contains(rideId);
        }).map((doc) {
          return RideRequest.fromMap(doc.data());
        }).toList();
      },
    ).handleError((error) {
      print('Error fetching pre-booked rides: $error');
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
    required String status,
  }) async {
    try {
      final rideRequest = await getRideRequestDetails(requestId);

      final completedRidesRef =
          ApiUrl.driverRides.doc(driverId).collection('driver_rides').doc();

      final rideRequestModel = RideRequest(
        id: rideRequest.id,
        driverId: rideRequest.driverId,
        userId: rideRequest.userId,
        preBookRideTime: rideRequest.preBookRideTime,
        preBookRideDate: rideRequest.preBookRideDate,
        isScheduled: rideRequest.isScheduled,
        userName: rideRequest.userName,
        startLocation: rideRequest.startLocation,
        endLocation: rideRequest.endLocation,
        vehicleType: rideRequest.vehicleType,
        price: rideRequest.price,
        status: status,
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
          await ApiUrl.driverRides.doc(driverId).collection('driver_rides').get();

      final completedRides = querySnapshot.docs.map((doc) {
        return RideRequest.fromMap(doc.data());
      }).toList();

      return completedRides;
    } catch (e) {
      throw Exception('Failed to fetch completed ride requests: $e');
    }
  }
}
