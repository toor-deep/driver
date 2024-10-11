import '../../data/model/ride_request_model.dart';
import '../../data/repository/ride_request_repository.dart';
import '../entity/requested_ride.dart';

class GetAllPendingRideRequestsForDriverUseCase {
  final DriverRideRequestRepository repository;

  GetAllPendingRideRequestsForDriverUseCase(this.repository);

  Stream<List<RideRequestEntity>> call(String driverId) {
    return repository.getAllPendingRideRequestsForDriver(driverId);
  }
}
