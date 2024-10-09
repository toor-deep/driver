import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';

import '../../data/data_source/ride_request_data_source.dart';
import '../../data/model/ride_request_model.dart';
import '../../data/repository/ride_request_repository.dart';

class DriverRideRequestRepositoryImpl implements DriverRideRequestRepository {
  final DriverRideRequestDataSource dataSource;

  DriverRideRequestRepositoryImpl(this.dataSource);

  @override
  Future<void> updateRideRequestStatus({
    required String requestId,
    required String status,
    required String driverId
  }) {
    return dataSource.updateRideRequestStatus(
      requestId: requestId,
      status: status,
      driverId: driverId
    );
  }

  @override
  @override
  Stream<List<RideRequestEntity>> getAllPendingRideRequestsForDriver() {
    return dataSource.getAllPendingRideRequestsForDriver().map((rideRequests) {
      return rideRequests.map((rideRequest) => rideRequest.toEntity()).toList();
    });
  }

  @override
  Future<RideRequestEntity> getRideRequestDetails(String requestId) async {
    final data = await dataSource.getRideRequestDetails(requestId);
    return data.toEntity();
  }

  @override
  Future<void> saveCompletedOrCanceledRide(
      {required String driverId, required String requestId}) async {
    return await dataSource.saveCompletedOrCanceledRide(
        driverId: driverId, requestId: requestId);
  }

  @override
  Future<List<RideRequestEntity>> getCompletedRideRequestsForDriver(
      String driverId) async {
    final rideRequests =
        await dataSource.getCompletedRideRequestsForDriver(driverId);

    return rideRequests.map((rideRequest) => rideRequest.toEntity()).toList();
  }

  @override
  Stream<List<RideRequestEntity>> getPreBookedRidesForDriver(String driverId) {
    return dataSource.getPreBookedRidesForDriver(driverId).map((rideRequests) {
      return rideRequests.map((rideRequest) => rideRequest.toEntity()).toList();
    });
  }
}
