import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Privacy Policy",
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 20),
              const Text(
                "This is the privacy policy of the application. We value your privacy and are committed to protecting your personal information. By using the app, you agree to the terms outlined in this privacy policy. We collect minimal user data for service improvements...",
              ),
              const SizedBox(height: 10),
              const Text(
                "1. Data Collection",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We collect data such as location, contact details, and other necessary information to provide the best service.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
