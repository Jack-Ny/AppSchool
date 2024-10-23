import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigation automatique après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir les dimensions de l'écran pour la responsivité
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.width * 0.6,
              height: screenSize.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Points décoratifs
                  Positioned(
                    top: 20,
                    right: 30,
                    child: _buildDecorationDot(8),
                  ),
                  Positioned(
                    top: 15,
                    right: 50,
                    child: _buildDecorationDot(12),
                  ),

                  // Icône centrale
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: AppColors.primaryBlue,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'TPsc',
              style: AppTextStyles.appName,
            ),
            const Text(
              'DEVIENS UN GENIE',
              style: AppTextStyles.slogan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorationDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
