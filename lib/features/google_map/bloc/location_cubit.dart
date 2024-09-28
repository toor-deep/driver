import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState.initial());

  late Position position;

  Future<void> checkLocationPermission() async {
    emit(state.copyWith(isLoading: true));

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Try to open the location settings so the user can enable it
      await Geolocator.openLocationSettings();
      emit(state.copyWith(isLocationEnabled: false, isLoading: false));
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(isLocationEnabled: false, isLoading: false));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(state.copyWith(isLocationEnabled: false, isLoading: false));
      return;
    }

    try {
      // If permissions are granted, get the current location
      Position position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(position: position, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
