import 'package:flutter/material.dart';
import 'package:maji_freshi/screens/onboarding_screen.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      _navigateToOnboarding();
    }
  }

  void _navigateToOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_water.png',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay Gradient for blueish water look
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlueAccent.withOpacity(0.3),
                    Colors.blue.withOpacity(0.6),
                    Colors.blue.shade900.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // App Name with Calligraphy
                Text(
                  'Maji Freshi',
                  style: GoogleFonts.greatVibes(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    shadows: [
                      const Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pure Water, Pure Life',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Continue Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _navigateToOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
