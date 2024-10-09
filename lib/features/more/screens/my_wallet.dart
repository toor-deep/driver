import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_bloc.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_state.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RideCubit>().getCompletedRides();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RequestedRideState>(
      builder: (context, state) {
        // Filter rides where status is 'completed'
        final completedRides = (state.requestedRides ?? [])
            .where((ride) => ride.status == 'completed')
            .toList();

        // Calculate total balance from completed rides
        double totalBalance =
            completedRides.fold(0, (sum, ride) => sum + ride.price);

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Wallet'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet balance
                const Text(
                  "Current Balance",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  "\$${totalBalance.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Recent Transactions header
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                if (completedRides.isNotEmpty) ...[
                  Expanded(
                    child: ListView(
                      children: completedRides.map((ride) {
                        return TransactionTile(
                          title: 'Ride Completed',
                          amount: '+\$${ride.price.toStringAsFixed(2)}',
                          date: ride.createdAt
                              .toString(), // Format date as needed
                        );
                      }).toList(),
                    ),
                  ),
                ] else ...[
                  const Center(child: Text("No Transaction"))
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const TransactionTile({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(date, style: const TextStyle(color: Colors.grey)),
      trailing: Text(
        amount,
        style: TextStyle(
          fontSize: 16,
          color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
