import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/singn_in_screen.dart';
import 'package:urban_estate/view/widgets/clickCartText.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: responsive.space(28)),
            Text(
              'Welcome to',
              style: poppinsRegular.copyWith(fontSize: responsive.font(18)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Clickcarttext(fontSize: responsive.font(36)),
              ),
            ),
            SizedBox(height: responsive.space(48)),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Image.asset(
                'assets/images/onboarding_home.png',
                height: responsive.height * 0.58,
                width: responsive.width,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: responsive.space(22)),
            const GetStartedWidget(),
          ],
        ),
      ),
    );
  }
}

class GetStartedWidget extends StatelessWidget {
  const GetStartedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 182, 229, 7),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.space(56),
            vertical: responsive.space(16),
          ),
        ),
        onPressed: () {
          Get.to(() => SingnInScreen());
        },
        child: Text(
          'Get Started',
          style: poppinsSemiBold.copyWith(
            color: Colors.black,
            fontSize: responsive.font(17),
          ),
        ),
      ),
    );
  }
}
