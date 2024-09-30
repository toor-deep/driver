import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:go_router/go_router.dart';
import 'package:rickshaw_driver_app/features/ride_requests/domain/entity/requested_ride.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';
import 'package:rickshaw_driver_app/shared/dialog.dart';
import '../../../../shared/constants.dart';

class IncomingRidesScreen extends StatefulWidget {
  const IncomingRidesScreen({super.key});

  @override
  State<IncomingRidesScreen> createState() => _IncomingRidesScreenState();
}

class _IncomingRidesScreenState extends State<IncomingRidesScreen> {
  @override
  void initState() {
    context.read<RideCubit>().getAllRidesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RequestedRideState>(
      builder: (context, state) {
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: listView(state.requestedRides ?? []),
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

  Widget listView(List<RideRequestEntity> requestedRides) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            final item = requestedRides[index];
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
                      subtitle: const Text("jhgffghj"),
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
                                  ),
                                ),
                              ),
                              const Dash(
                                direction: Axis.vertical,
                                length: 40,
                                dashLength: 6,
                              ),
                              const Icon(
                                Icons.location_on,
                                size: 30,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                  Text(
                                    item.startLocation,
                                  ),
                                  Spacing.hlg,
                                  const Text(
                                    "End Location",
                                  ),
                                  Text(
                                    item.endLocation,
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
                                onPressed: () {}, child: const Text('Accept')),
                          ),
                          Spacing.wlg,
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showDeleteDialog(
                                    context: context, onTap: () {});
                              },
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.red)),
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
          },
          separatorBuilder: (context, index) => SizedBox(
                height: 0.02.sh,
              ),
          itemCount: requestedRides.length),
    );
  }
}
