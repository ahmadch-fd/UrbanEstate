import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final Color limeColor = const Color(0xFFB6E507);
    final Color darkIconColor = const Color(0xFF004E47);

    return Scaffold(
      body: Stack(
        children: [
          // 1. The Background Content (PageView)
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) => controller.currentIndex.value = index,
            itemCount: controller.screens.length,
            itemBuilder: (context, index) => controller.screens[index],
          ),

          // 2. The Floating Navigation Bar (Exact match to image)
          Positioned(
            bottom: 30, // Adjust height from bottom
            left: 20,
            right: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(0, Icons.home_filled, controller, limeColor, darkIconColor),
                  _navItem(1, Icons.favorite_border, controller, limeColor, darkIconColor),
                  _navItem(2, Icons.add_circle_outline, controller, limeColor, darkIconColor),
                  _navItem(3, Icons.chat_bubble_outline, controller, limeColor, darkIconColor),
                  _navItem(4, Icons.person_outline, controller, limeColor, darkIconColor),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, OnboardingController controller, Color lime, Color dark) {
    bool isActive = controller.currentIndex.value == index;
    
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? lime : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? dark : dark.withOpacity(0.6),
          size: 28,
        ),
      ),
    );
  }
}