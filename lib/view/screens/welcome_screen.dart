import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/view/screens/singn_in_screen.dart';
import 'package:urban_estate/view/widgets/clickCartText.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: height * 0.04),
            Text('Welcome to', style: poppinsRegular.copyWith(fontSize: 18)),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Clickcarttext(fontSize: 36),
              ),
            ),
            SizedBox(height: height * 0.08),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Image.asset(
                'assets/images/onboarding_home.png',
                height: height * 0.60,
                width: width * 1,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: height * 0.03),
            GetStartedWidget(width: width, height: height),
          ],
        ),
      ),
    );
  }
}

class GetStartedWidget extends StatelessWidget {
  const GetStartedWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 182, 229, 7),
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.15,
            vertical: height * 0.02,
          ),
        ),
        onPressed: () {
          Get.to(() => SingnInScreen());
        },
        child: Text(
          'Get Started',
          style: poppinsSemiBold.copyWith(color: Colors.black, fontSize: 17),
        ),
      ),
    );
  }
}
