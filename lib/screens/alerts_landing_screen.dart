import 'package:flutter/material.dart';

class AlertsLandingScreen extends StatelessWidget {
  const AlertsLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: const Center(
        child: Text('Alerts landing'),
      ),
    );
  }
}
