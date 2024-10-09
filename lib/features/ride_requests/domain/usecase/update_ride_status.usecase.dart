import '../../data/repository/ride_request_repository.dart';

class UpdateRideRequestStatusUseCase {
  final DriverRideRequestRepository repository;

  UpdateRideRequestStatusUseCase(this.repository);

  Future<void> call(UpdateRideRequestStatusParams params) {
    return repository.updateRideRequestStatus(
      requestId: params.requestId,
      status: params.status,
      driverId: params.driverId
    );
  }
}

class UpdateRideRequestStatusParams {
  final String requestId;
  final String status;
   String driverId;

  UpdateRideRequestStatusParams(
      {required this.requestId, required this.status,required this.driverId});
}
