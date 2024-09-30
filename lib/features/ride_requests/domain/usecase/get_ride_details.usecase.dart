import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';

import '../../data/model/ride_request_model.dart';
import '../../data/repository/ride_request_repository.dart';

class GetRideRequestDetailsUseCase {
  final DriverRideRequestRepository repository;

  GetRideRequestDetailsUseCase(this.repository);

  Future<RideRequestEntity> call(String requestId) {
    return repository.getRideRequestDetails(requestId);
  }
}