
import '../../domain/entity/requested_ride.dart';
import '../model/ride_request_model.dart';

abstract class DriverRideRequestRepository {
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
  });

  Future<List<RideRequestEntity>> getAllPendingRideRequestsForDriver();

  Future<RideRequestEntity> getRideRequestDetails(String requestId);
}
