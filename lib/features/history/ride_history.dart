import 'package:flutter/material.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            RideHistoryTile(
              rideDate: 'Sep 27, 2024',
              startLocation: 'Downtown',
              endLocation: 'Uptown',
              fare: '\$15.00',
              status: 'Completed',
            ),
            RideHistoryTile(
              rideDate: 'Sep 26, 2024',
              startLocation: 'City Center',
              endLocation: 'Mall',
              fare: '\$10.50',
              status: 'Completed',
            ),
            RideHistoryTile(
              rideDate: 'Sep 25, 2024',
              startLocation: 'Westside',
              endLocation: 'Eastside',
              fare: '\$20.00',
              status: 'Cancelled',
            ),
          ],
        ),
      ),
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
            Text(
              "Status: $status",
              style: TextStyle(
                fontSize: 14,
                color: status == 'Completed' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
