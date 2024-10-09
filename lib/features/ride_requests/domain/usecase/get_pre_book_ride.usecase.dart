import '../../data/model/ride_request_model.dart';
import '../../data/repository/ride_request_repository.dart';
import '../entity/requested_ride.dart';

class GetAllPreBookRideRequestsForDriverUseCase {
  final DriverRideRequestRepository repository;

  GetAllPreBookRideRequestsForDriverUseCase(this.repository);

  Stream<List<RideRequestEntity>> call(String driverId) {
    return repository.getPreBookedRidesForDriver(driverId);
  }
}
