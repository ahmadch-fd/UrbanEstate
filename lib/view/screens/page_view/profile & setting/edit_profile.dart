import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/controllers/name&location_controller.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/view/screens/page_view/page_view.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/profile_screen.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/date_picker.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/dial_code_picker.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/region_textfield.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/text_form_field.dart';
import 'package:urban_estate/view/widgets/circular_icon_button.dart';
import 'package:urban_estate/view/widgets/custom_button.dart';
import 'package:urban_estate/view/widgets/tostification.dart';
import 'package:toastification/src/core/toastification_overlay_state.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});
  @override
  Widget build(BuildContext context) {
    final ImagePickerController controller = Get.put(ImagePickerController());
    final NameLocationController nameLocationController = Get.put(
      NameLocationController(),
    );
    final OnboardingController onboardingController =
        Get.find<OnboardingController>();
    final PageController pageController = PageController();

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    circleIconButton(
                      Icons.arrow_back_ios_new,
                      bgColor: AppColors.forestGreen,
                      ontap: () => Get.back(),
                    ),
                    SizedBox(width: width * 0.23),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return Stack(
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: controller.imagePath.isNotEmpty
                              ? FileImage(File(controller.imagePath.toString()))
                                    as ImageProvider
                              : AssetImage(
                                  'assets/images/profile_placeholder.png',
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 9,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          showImageSourceDialog(controller);
                        },
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.1,
                          decoration: BoxDecoration(
                            color: AppColors.forestGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingText(text: 'Name'),
                  SizedBox(height: height * 0.007),
                  MyTextFormField(
                    textcontroller: nameLocationController.nameController.value,
                  ),
                  SizedBox(height: height * 0.012),
                  HeadingText(text: 'Phone'),
                  SizedBox(height: height * 0.007),
                  DialCodePicker(),
                  HeadingText(text: 'Date of Birth'),
                  SizedBox(height: height * 0.007),
                  DatePicker(),
                  SizedBox(height: height * 0.012),
                  HeadingText(text: 'City/Province'),
                  SizedBox(height: height * 0.007),
                  RegionTextfield(),
                  SizedBox(height: height * 0.007),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: CustomButton(
                      textColor: Colors.white,
                      color: AppColors.forestGreen,
                      label: 'Save',
                      onTap: () {
                        // Switch the main PageView to the Profile tab and close this screen
                        onboardingController.changePage(4);
                        Get.back();
                        Get.snackbar(
                          "Success", // Title
                          "Saved Successfully!", // Message
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(
                            0xFF004D40,
                          ), // Forest Green
                          colorText: Colors.white,
                          borderRadius: 15,
                          margin: const EdgeInsets.all(15),
                          duration: const Duration(seconds: 2),
                          isDismissible: true,
                          forwardAnimationCurve: Curves.easeOutBack,

                          // Icon and Lime Accent
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFFC6FF00),
                            size: 30,
                          ),
                          leftBarIndicatorColor: const Color(0xFFC6FF00),

                          // Shadow for "Floating" effect
                          boxShadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: poppinsRegular.copyWith(fontSize: 15));
  }
}

void showImageSourceDialog(ImagePickerController controller) {
  //  ImagePickerController controller = Get.put(ImagePickerController());
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Takes only as much space as needed
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => controller.pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () => controller.pickImage(ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}
