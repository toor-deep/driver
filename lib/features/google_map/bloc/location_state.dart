import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class LocationState extends Equatable {
  final bool isLoading;
  final bool isLocationEnabled;
  final bool isPermissionGranted;
  final Position? position;
  final String? errorMessage;

  const LocationState({
    required this.isLoading,
    required this.isLocationEnabled,
    required this.isPermissionGranted,
    this.position,
    this.errorMessage,
  });

  factory LocationState.initial() {
    return LocationState(
      isLoading: false,
      isLocationEnabled: true,
      isPermissionGranted: true,
      position: null,
      errorMessage: null,
    );
  }

  LocationState copyWith({
    bool? isLoading,
    bool? isLocationEnabled,
    bool? isPermissionGranted,
    Position? position,
    String? errorMessage,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      position: position ?? this.position,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLocationEnabled,
    isPermissionGranted,
    position,
    errorMessage,
  ];
}
