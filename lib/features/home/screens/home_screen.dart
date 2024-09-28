import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rickshaw_driver_app/features/google_map/bloc/location_state.dart';
import '../../current_user/presentation/bloc/user_cubit.dart';
import '../../google_map/bloc/location_cubit.dart';
import '../../google_map/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isOnline = true;
  late UserCubit userCubit;
  late LatLng currentPosition;

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserCubit>();
    context.read<LocationCubit>().checkLocationPermission();
    userCubit.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state.position != null) {
          currentPosition =
              LatLng(state.position!.latitude, state.position!.longitude);
        } else {
          currentPosition = const LatLng(37.7749, -122.4194);
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [
            MapSample(
              currentLocation: currentPosition,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
              child: _buildOverlay(),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildOverlay() {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.9),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isOnline ? "Online" : "Offline",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                ),
                Switch(
                  value: isOnline,
                  activeTrackColor: Theme.of(context).primaryColor,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      isOnline = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
