
import '../../domain/entity/requested_ride.dart';
import '../model/ride_request_model.dart';

abstract class DriverRideRequestRepository {
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
    required String driverId
  });
  Stream<List<RideRequestEntity>> getPreBookedRidesForDriver(String driverId);

  Stream<List<RideRequestEntity>>  getAllPendingRideRequestsForDriver();

  Future<RideRequestEntity> getRideRequestDetails(String requestId);
  Future<void> saveCompletedOrCanceledRide({
    required String driverId,
    required String requestId
  });
  Future<List<RideRequestEntity>> getCompletedRideRequestsForDriver(String driverId);

}
