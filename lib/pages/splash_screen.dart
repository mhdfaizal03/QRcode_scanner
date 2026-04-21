import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotech_app/decoration.dart';
import 'package:gotech_app/pages/dashboard_page.dart';
import 'package:gotech_app/widgets/responsive_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.off(() => const DashboardPage(),
        transition: Transition.fadeIn, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    // RESTORED HIERARCHY: Background Scaffold -> Centered Content
    return StartBackgroundColor(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: MaxWidthContainer(
            maxWidth: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EntranceAnimation(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withValues(alpha: 0.2),
                              blurRadius: 40,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'VISIONARY',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'QR INTELLIGENCE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
