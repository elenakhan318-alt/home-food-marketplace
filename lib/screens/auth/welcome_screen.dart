import 'package:flutter/material.dart';

import '../cook/cook_dashboard_screen.dart';
import '../customer/customer_main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              const Icon(
                Icons.restaurant_menu,
                size: 72,
                color: Colors.orange,
              ),

              const SizedBox(height: 24),

              const Text(
                'Home Food Marketplace',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Discover trusted home cooks and fresh meals across Birmingham.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),

              const Spacer(),

              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerMainScreen(),
                    ),
                  );
                },
                child: const Text('Continue as Customer'),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CookDashboardScreen(),
                    ),
                  );
                },
                child: const Text('Become a Home Cook'),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  // Sign in screen will be added later.
                },
                child: const Text('Already have an account? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}