import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/add_property.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/add_property_screen.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_screen.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/profile_screen.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  // Reactive index for the floating nav bar
  var currentIndex = 0.obs;

  // Replace these Containers with your actual Screen Widgets
  final List<Widget> screens = [
    HomeScreen(),
    Container(
      color: Colors.grey[100],
      child: const Center(child: Text("Favorites Screen")),
    ),
    PostPropertyScreen(),
    Container(
      color: Colors.grey[100],
      child: const Center(child: Text("Messages")),
    ),
    ProfileScreen(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
