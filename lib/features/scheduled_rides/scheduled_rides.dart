import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rickshaw_driver_app/shared/toast_alert.dart';

import '../../shared/casting.dart';
import '../../shared/constants.dart';
import '../../shared/dialog.dart';
import '../current_user/presentation/bloc/user_cubit.dart';
import '../ride_requests/domain/entity/requested_ride.dart';
import '../ride_requests/domain/usecase/update_ride_status.usecase.dart';
import '../ride_requests/presentation/bloc/ride_request_bloc.dart';
import '../ride_requests/presentation/bloc/ride_request_state.dart';
import '../ride_requests/presentation/screens/distance_tracking_screen.dart';

class ScheduledRides extends StatefulWidget {
  const ScheduledRides({super.key});

  @override
  State<ScheduledRides> createState() => _IncomingRidesScreenState();
}

class _IncomingRidesScreenState extends State<ScheduledRides> {
  late RideCubit rideCubit;

  @override
  void initState() {
    rideCubit = context.read<RideCubit>();
    context.read<RideCubit>().getAllPreBookRidesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RequestedRideState>(
      builder: (context, state) {
        final userCubit = context.read<UserCubit>();
        final isOnline = userCubit.isOnline;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Scheduled Rides"),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: isOnline
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        if (state.isLoading == true) ...[
                          const Center(child: CircularProgressIndicator())
                        ] else ...[
                          if ((state.requestedRides ?? []).isNotEmpty) ...[
                            Expanded(
                              child: ListView(
                                children: [
                                  listView(state.requestedRides ?? []),
                                ],
                              ),
                            )
                          ] else ...[
                            const Center(child: Text('No Scheduled Rides'))
                          ]
                        ],
                      ])
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You are currently offline. Please go online to view ride requests.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget listView(List<RideRequestEntity> requestedRides) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = requestedRides[index];
        return preBookingRideView(item);
      },
      separatorBuilder: (context, index) => SizedBox(height: 0.02.sh),
      itemCount: requestedRides.length,
    );
  }

  Widget preBookingRideView(RideRequestEntity item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(),
              title: Text(item.userName ?? "",
                  style: Theme.of(context).textTheme.displayMedium),
              trailing: Text("Rs.${item.price.toStringAsFixed(0)}",
                  style: Theme.of(context).textTheme.displayMedium),
            ),
            Spacing.hmed,
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 7,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                      Dash(
                        direction: Axis.vertical,
                        length: 40,
                        dashLength: 6,
                        dashColor: Theme.of(context).secondaryHeaderColor,
                      ),
                      Icon(
                        Icons.location_on,
                        size: 30,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Start Location",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    Text(item.startLocation),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    Text(extractDate(item.preBookRideDate ?? "")),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Spacing.hlg,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("End Location",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    Text(item.endLocation),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Time",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    Text(item.preBookRideTime ?? ""),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.hmed,
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final DateTime now = DateTime.now();

                        // Pre-book ride date from server (format: '2024-10-11T00:00:00.000')
                        final String rideDate = item.preBookRideDate ?? "";
                        // Ride time string (format: '09:25 PM')
                        final String rideTime = item.preBookRideTime ?? "";

                        // Parse the ride date (assuming it follows ISO 8601 format)
                        DateTime? scheduledDate = DateTime.tryParse(rideDate);

                        if (scheduledDate == null) {
                          showSnackbar("Invalid ride date.", Colors.red);
                          return;
                        }

                        // Parse the time string (format: '09:25 PM') into TimeOfDay
                        final timeFormat =
                            DateFormat.jm(); // 'h:mm a' format like '09:25 PM'
                        DateTime? parsedTime;

                        try {
                          parsedTime = timeFormat.parse(rideTime);
                        } catch (e) {
                          showSnackbar("Invalid ride time.", Colors.red);
                          return;
                        }

                        // Combine the parsed date and time into a single DateTime object
                        final scheduledDateTime = DateTime(
                          scheduledDate.year,
                          scheduledDate.month,
                          scheduledDate.day,
                          parsedTime.hour, // Get hour from parsed time
                          parsedTime.minute, // Get minute from parsed time
                        );

                        // Define a 30-minute window before and after the scheduled time
                        final DateTime minStartTime = scheduledDateTime
                            .subtract(const Duration(minutes: 30));
                        final DateTime maxStartTime =
                            scheduledDateTime.add(const Duration(minutes: 30));

                        // Check if the current time is within the allowed time window
                        if (now.isBefore(minStartTime)) {
                          showSnackbar(
                            "You can only start the ride 30 minutes before the scheduled time.",
                            Colors.red,
                          );
                        } else if (now.isAfter(maxStartTime)) {
                          showSnackbar(
                            "You can only start the ride up to 30 minutes after the scheduled time.",
                            Colors.red,
                          );
                        } else {
                          // Proceed to start the ride if the current time is within the allowed window
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DistanceTrackingScreen(
                                requestId: item.id ?? "",
                              ),
                            ),
                          );
                        }
                      },
                      child: rideCubit.state.isLoading == true
                          ? const CircularProgressIndicator()
                          : const Text('Start'),
                    ),
                  ),
                  Spacing.wlg,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDeleteDialog(
                            context: context,
                            onTap: () {
                              context
                                  .read<RideCubit>()
                                  .completeRide(item.id ?? "",'cancelled', () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              });
                            });
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red)),
                      child: Text(
                        'Declined',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
