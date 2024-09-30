
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/usecase/get_ride_request.usecase.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import '../../domain/usecase/get_ride_details.usecase.dart';
import '../../domain/usecase/update_ride_status.usecase.dart';

class RideCubit extends Cubit<RequestedRideState> {
  final GetRideRequestDetailsUseCase getRideRequestDetailsUseCase;
  final UpdateRideRequestStatusUseCase updateRideRequestStatusUseCase;
  final GetAllPendingRideRequestsForDriverUseCase
      getAllPendingRideRequestsForDriverUseCase;

  RideCubit({
    required this.getRideRequestDetailsUseCase,
    required this.getAllPendingRideRequestsForDriverUseCase,
    required this.updateRideRequestStatusUseCase,
  }) : super(const RequestedRideState());

  bool isActiveRide = false;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> getRideRequestDetails(String rideId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getRideRequestDetailsUseCase.call(rideId);
      emit(state.copyWith(isLoading: false, rideRequestEntity: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getAllRidesList() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getAllPendingRideRequestsForDriverUseCase.call();
      emit(state.copyWith(isLoading: false, requestedRides: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> hasActiveRide(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final rides = await getAllPendingRideRequestsForDriverUseCase.call();

      if (rides.any((ride) => ride.status == 'active')) {
        isActiveRide = true;
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
