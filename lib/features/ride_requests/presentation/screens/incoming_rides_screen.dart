import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:go_router/go_router.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/usecase/update_ride_status.usecase.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/screens/distance_tracking_screen.dart';
import 'package:rickshaw_driver_app/shared/dialog.dart';
import '../../../../shared/casting.dart';
import '../../../../shared/constants.dart';
import '../../../current_user/presentation/bloc/user_cubit.dart';

class IncomingRidesScreen extends StatefulWidget {
  const IncomingRidesScreen({super.key});

  @override
  State<IncomingRidesScreen> createState() => _IncomingRidesScreenState();
}

class _IncomingRidesScreenState extends State<IncomingRidesScreen> {
  late RideCubit rideCubit;

  @override
  void initState() {
    rideCubit = context.read<RideCubit>();
    context.read<RideCubit>().getAllRidesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RequestedRideState>(
      builder: (context, state) {
        final userCubit = context.read<UserCubit>();
        final isOnline = userCubit.isOnline;

        if (!isOnline) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You are currently offline. Please go online to view ride requests.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
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
                            // Instant Rides Section
                            if (_filterRides(state.requestedRides, false)
                                .isNotEmpty) ...[
                              _buildSectionTitle("Instant Rides"),
                              listView(
                                  _filterRides(state.requestedRides, false)),
                            ],
                            // Prebooked Rides Section
                            if (_filterRides(state.requestedRides, true)
                                .isNotEmpty) ...[
                              _buildSectionTitle("Prebooked Rides"),
                              listView(
                                  _filterRides(state.requestedRides, true)),
                            ],
                          ],
                        ),
                      )
                    ] else ...[
                      const Center(child: Text('No Request Yet'))
                    ]
                  ],
                ]),
          ),
        );
      },
    );
  }

  List<RideRequestEntity> _filterRides(
      List<RideRequestEntity>? rides, bool isScheduled) {
    return rides?.where((ride) => ride.isScheduled == isScheduled).toList() ??
        [];
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget listView(List<RideRequestEntity> requestedRides) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = requestedRides[index];
        if (item.isScheduled) {
          return preBookingRideView(item);
        } else {
          return instantRideView(item);
        }
      },
      separatorBuilder: (context, index) => SizedBox(height: 0.02.sh),
      itemCount: requestedRides.length,
    );
  }

  Widget instantRideView(RideRequestEntity item) {
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
              title: Text(item.userName,
                  style: Theme.of(context).textTheme.displayMedium),
              trailing: Text(item.price.toString(),
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
                          Text("Start Location",
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(item.startLocation),
                          Spacing.hlg,
                          Text("End Location",
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(item.endLocation),
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
                        context.read<RideCubit>().updateRideStatus(
                            UpdateRideRequestStatusParams(
                                requestId: item.id, status: 'accepted'), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DistanceTrackingScreen(
                                  requestId: item.id ?? "",
                                ),
                              ));
                        });
                      },
                      child: rideCubit.state.isLoading == true
                          ? const CircularProgressIndicator()
                          : const Text('Accept'),
                    ),
                  ),
                  Spacing.wlg,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDeleteDialog(
                            context: context,
                            onTap: () {
                              context.read<RideCubit>().updateRideStatus(
                                  UpdateRideRequestStatusParams(
                                      requestId: item.id ?? "",
                                      status: 'cancelled'), () {
                                context
                                    .read<RideCubit>()
                                    .completeRide(item.id ?? "");
                              });
                            });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
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
              trailing: Text(item.price.toString(),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Location",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                  Text(item.startLocation),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Date",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                  Text(extractDate(item.preBookRideDate ?? "")),
                                ],
                              )
                            ],
                          ),
                          Spacing.hlg,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End Location",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                  Text(item.endLocation),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Time",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                  Text(item.preBookRideTime ?? ""),
                                ],
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
                        context.read<RideCubit>().updateRideStatus(
                            UpdateRideRequestStatusParams(
                                requestId: item.id, status: 'accepted'), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DistanceTrackingScreen(
                                        requestId: item.id ?? "",
                                      )));
                        });
                      },
                      child: rideCubit.state.isLoading == true
                          ? const CircularProgressIndicator()
                          : const Text('Accept'),
                    ),
                  ),
                  Spacing.wlg,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDeleteDialog(
                            context: context,
                            onTap: () {
                              context.read<RideCubit>().updateRideStatus(
                                  UpdateRideRequestStatusParams(
                                      requestId: item.id,
                                      status: 'cancelled'), () {
                                context
                                    .read<RideCubit>()
                                    .completeRide(item.id ?? "");
                              });
                            });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
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
