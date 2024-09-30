
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
  }) {
    return dataSource.updateRideRequestStatus(
      requestId: requestId,
      status: status,
    );
  }

  @override
  Future<List<RideRequestEntity>> getAllPendingRideRequestsForDriver() async {
    final rideRequests = await dataSource.getAllPendingRideRequestsForDriver();

    return rideRequests.map((rideRequest) => rideRequest.toEntity()).toList();
  }

  @override
  Future<RideRequestEntity> getRideRequestDetails(String requestId) async {
    final data = await dataSource.getRideRequestDetails(requestId);
    return data.toEntity();
  }
}
