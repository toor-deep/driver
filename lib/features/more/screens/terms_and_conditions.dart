import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of Service"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms of Service",
              ),
              SizedBox(height: 20),
              Text(
                "By using this app, you agree to the following terms and conditions. The app is provided to help connect drivers with customers for ride services. You must adhere to the following rules when using the app...",
              ),
              SizedBox(height: 10),
              Text(
                "1. User Responsibilities",
              ),
              SizedBox(height: 10),
              Text(
                "Users must provide accurate information and follow local laws and regulations while using the service.",
              ),

            ],
          ),
        ),
      ),
    );
  }
}
