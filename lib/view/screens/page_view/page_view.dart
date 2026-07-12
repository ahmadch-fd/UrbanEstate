import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';
import 'package:urban_estate/utils/responsive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OnboardingController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetToHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final Color limeColor = const Color(0xFFB6E507);
    final Color darkIconColor = const Color(0xFF004E47);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final shouldShowNav = bottomInset == 0;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) => controller.currentIndex.value = index,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.screens.length,
            itemBuilder: (context, index) => controller.screens[index],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            bottom: shouldShowNav
                ? safeBottom + responsive.space(16)
                : -responsive.scale(96),
            left: responsive.pagePadding,
            right: responsive.pagePadding,
            child: IgnorePointer(
              ignoring: !shouldShowNav,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: shouldShowNav ? 1 : 0,
                child: Container(
                  height: responsive.scale(68),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.space(8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: responsive.scale(18),
                        spreadRadius: responsive.scale(2),
                        offset: Offset(0, responsive.scale(8)),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _navItem(
                          context,
                          0,
                          Icons.home_filled,
                          controller,
                          limeColor,
                          darkIconColor,
                        ),
                        _navItem(
                          context,
                          1,
                          Icons.favorite_border,
                          controller,
                          limeColor,
                          darkIconColor,
                        ),
                        _navItem(
                          context,
                          2,
                          Icons.add_circle_outline,
                          controller,
                          limeColor,
                          darkIconColor,
                        ),
                        _navItem(
                          context,
                          3,
                          Icons.chat_bubble_outline,
                          controller,
                          limeColor,
                          darkIconColor,
                        ),
                        _navItem(
                          context,
                          4,
                          Icons.person_outline,
                          controller,
                          limeColor,
                          darkIconColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    int index,
    IconData icon,
    OnboardingController controller,
    Color lime,
    Color dark,
  ) {
    final responsive = Responsive.of(context);
    bool isActive = controller.currentIndex.value == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.changePage(index),
      child: SizedBox(
        width: responsive.scale(54),
        height: responsive.scale(54),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isActive ? lime : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? dark : dark.withValues(alpha: 0.6),
            size: responsive.icon(27),
          ),
        ),
      ),
    );
  }
}
