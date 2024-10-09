import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/usecase/completed_ride.usecase.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/usecase/get_pre_book_ride.usecase.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/usecase/get_ride_request.usecase.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import 'package:rickshaw_driver_app/shared/toast_alert.dart';
import '../../domain/usecase/get_ride_details.usecase.dart';
import '../../domain/usecase/update_ride_status.usecase.dart';

class RideCubit extends Cubit<RequestedRideState> {
  final GetRideRequestDetailsUseCase getRideRequestDetailsUseCase;
  final UpdateRideRequestStatusUseCase updateRideRequestStatusUseCase;
  final GetAllPendingRideRequestsForDriverUseCase
      getAllPendingRideRequestsForDriverUseCase;
  final CompleteRideUseCase completeRideUseCase;
  final GetAllPreBookRideRequestsForDriverUseCase
      getAllPreBookRideRequestsForDriverUseCase;

  RideCubit(
      {required this.getRideRequestDetailsUseCase,
      required this.getAllPendingRideRequestsForDriverUseCase,
      required this.updateRideRequestStatusUseCase,
      required this.getAllPreBookRideRequestsForDriverUseCase,
      required this.completeRideUseCase})
      : super(const RequestedRideState());

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

  void getAllRidesList() {
    emit(state.copyWith(isLoading: true));
    try {
      getAllPendingRideRequestsForDriverUseCase().listen((pendingRides) {
        emit(state.copyWith(isLoading: false, requestedRides: pendingRides));
      }, onError: (e) {
        emit(state.copyWith(isLoading: false));
      });
    } catch (e) {
      print(e);
    }
  }

  void getAllPreBookRidesList() {
    emit(state.copyWith(isLoading: true));
    try {
      getAllPreBookRideRequestsForDriverUseCase(userId ?? '').listen(
          (pendingRides) {
        emit(state.copyWith(isLoading: false, requestedRides: pendingRides));
      }, onError: (e) {
        emit(state.copyWith(isLoading: false));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateRideStatus(
      UpdateRideRequestStatusParams params, Function onSuccess) async {
    emit(state.copyWith(isLoading: true));
    try {
      await updateRideRequestStatusUseCase.call(params);
      emit(state.copyWith(isLoading: false));
      statusSet(params.status);
      if (params.status == 'accepted') {
        isActiveRide = true;
      }
      isActiveRide = false;
      onSuccess();
    } catch (e) {
      print(e);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> completeRide(String requestId,Function onSuccess) async {
    try {
      emit(state.copyWith(isLoading: true));
      await completeRideUseCase.call(
        requestId: requestId,
        id: userId ?? "",
      );
      emit(state.copyWith(isLoading: false));
      onSuccess();
    } catch (e) {
      print('Failed to complete the ride: $e');
    }
  }

  Future<void> getCompletedRides() async {
    emit(state.copyWith(isLoading: true));
    try {
      final data =
          await completeRideUseCase.getCompletedRides(driverId: userId ?? "");
      emit(state.copyWith(isLoading: false, requestedRides: data));
    } catch (e) {
      print(e);
    }
  }

// Future<void> hasActiveRide(String userId) async {
//   emit(state.copyWith(isLoading: true));
//   try {
//     final rides = await getAllPendingRideRequestsForDriverUseCase.call();
//
//     if (await rides.any((ride) => ride. == 'active')) {
//       isActiveRide = true;
//     }
//   } catch (e) {
//     emit(state.copyWith(isLoading: false));
//   } finally {
//     emit(state.copyWith(isLoading: false));
//   }
// }

  void statusSet(String status) {
    if (status == 'accepted') {
      showSnackbar('Ride request accepted successfully.', Colors.green);
    } else if (status == 'cancelled') {
      showSnackbar('Ride request declined successfully.', Colors.green);
    } else {}
  }
}
