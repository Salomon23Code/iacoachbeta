import 'dart:async';

import 'package:flutter/material.dart';

import '../onbording/welcom_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F2ED),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    size: 48,
                    color: Color(0xFF006B57),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'AI COACH',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF073B32),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Habitudes • Énergie • Discipline',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 40),

                const CircularProgressIndicator(color: Color(0xFF006B57)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
