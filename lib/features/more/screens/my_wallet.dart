import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "\$123.45", // Replace with actual balance
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Withdraw button
            SizedBox(
              width: double.infinity, // Full width button
              child: ElevatedButton(
                onPressed: () {
                  // Handle withdraw button click
                },
                child: const Text('Withdraw'),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Transactions header
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Example of transaction items
            Expanded(
              child: ListView(
                children: const [
                  TransactionTile(
                    title: 'Ride Completed',
                    amount: '+\$50.00',
                    date: 'Sep 27, 2024',
                  ),
                  TransactionTile(
                    title: 'Ride Completed',
                    amount: '+\$30.00',
                    date: 'Sep 26, 2024',
                  ),
                  TransactionTile(
                    title: 'Withdrawal',
                    amount: '-\$20.00',
                    date: 'Sep 25, 2024',
                  ),
                  // Add more TransactionTile widgets here
                ],
              ),
            ),
          ],
        ),
      ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(date, style: const TextStyle(color: Colors.grey)),
      trailing: Text(
        amount,
        style: TextStyle(
            fontSize: 16,
            color: amount.startsWith('-') ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}


