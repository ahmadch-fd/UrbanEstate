import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/view/screens/page_view/favorite_screen.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/add_property.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_screen.dart';
import 'package:urban_estate/view/screens/page_view/message_screen.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/profile_screen.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  // Reactive index for the floating nav bar
  var currentIndex = 0.obs;

  // Replace these Containers with your actual Screen Widgets
  final List<Widget> screens = [
    HomeScreen(),
    FavoriteScreen(),
    PostPropertyScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

  void changePage(int index) {
    if (index == 0 && Get.isRegistered<PropertyListingController>()) {
      Get.find<PropertyListingController>().clearTenantTypeFilter();
    }
    if (index == 3 && Get.isRegistered<MessageController>()) {
      Get.find<MessageController>().loadThreads();
    }

    if (index == currentIndex.value) return;
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void resetToHome() {
    currentIndex.value = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
