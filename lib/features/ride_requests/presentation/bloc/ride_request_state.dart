import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';

class RequestedRideState {
  final bool? isLoading;
  final List<RideRequestEntity>? requestedRides;
  final RideRequestEntity? rideRequestEntity;

  const RequestedRideState(
      {this.isLoading, this.requestedRides = const [], this.rideRequestEntity});

  RequestedRideState copyWith(
      {bool? isLoading,
      List<RideRequestEntity>? requestedRides,
      RideRequestEntity? rideRequestEntity}) {
    return RequestedRideState(
      isLoading: isLoading ?? this.isLoading,
      rideRequestEntity: rideRequestEntity ?? this.rideRequestEntity,
      requestedRides: requestedRides ?? this.requestedRides,
    );
  }
}
