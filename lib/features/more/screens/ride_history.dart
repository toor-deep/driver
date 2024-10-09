import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  void initState() {
    context.read<RideCubit>().getCompletedRides();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RequestedRideState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ride History"),
          ),
          body: state.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((state.requestedRides ?? []).isNotEmpty) ...[
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 0.02.sh,
                            ),
                            itemCount: state.requestedRides?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = state.requestedRides?[index];
                              return RideHistoryTile(
                                rideDate: (item?.createdAt ?? "").toString(),
                                startLocation: item?.startLocation ?? "",
                                endLocation: item?.endLocation ?? "",
                                fare: (item?.price ?? 0).toString(),
                                status: item?.status ?? "",
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        const Center(child: Text("No History yet"))
                      ]
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class RideHistoryTile extends StatelessWidget {
  final String rideDate;
  final String startLocation;
  final String endLocation;
  final String fare;
  final String status;

  const RideHistoryTile({
    Key? key,
    required this.rideDate,
    required this.startLocation,
    required this.endLocation,
    required this.fare,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rideDate,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "From: $startLocation",
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "To: $endLocation",
                    ),
                  ],
                ),
                Text(
                  fare,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(status,
                style: TextStyle(
                  fontSize: 14,
                  color: status == 'completed' ? Colors.green : Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
