import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';
import 'package:urban_estate/controllers/user_profile_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/date_picker.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/dial_code_picker.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/region_textfield.dart';
import 'package:urban_estate/view/screens/page_view/profile%20&%20setting/widgets/text_form_field.dart';
import 'package:urban_estate/view/widgets/circular_icon_button.dart';
import 'package:urban_estate/view/widgets/custom_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final imageController = Get.put(ImagePickerController());
  final profileController = Get.put(UserProfileController(), permanent: true);

  final nameController = TextEditingController();
  final dateController = TextEditingController();

  String phone = '';
  String city = 'Lahore, Punjab';

  @override
  void initState() {
    super.initState();
    _fillFromProfile();
    profileController.loadProfile().then((_) {
      if (!mounted) return;
      setState(_fillFromProfile);
    });
  }

  void _fillFromProfile() {
    final profile = profileController.profile.value;
    if (profile == null) return;

    nameController.text = profile.fullName;
    phone = profile.phone;
    dateController.text = profile.dateOfBirth ?? '';
    if (profile.location.isNotEmpty) {
      city = profile.location;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<OnboardingController>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    circleIconButton(
                      Icons.arrow_back_ios_new,
                      bgColor: AppColors.forestGreen,
                      ontap: () => Get.back(),
                    ),
                    SizedBox(width: width * 0.23),
                    const Text(
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
              Obx(
                () => Stack(
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _profileImage(
                            imageController.imagePath.value,
                            profileController.profile.value?.avatarUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 9,
                      right: 8,
                      child: InkWell(
                        onTap: () => showImageSourceDialog(imageController),
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.1,
                          decoration: const BoxDecoration(
                            color: AppColors.forestGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeadingText(text: 'Name'),
                  SizedBox(height: height * 0.007),
                  MyTextFormField(textcontroller: nameController),
                  SizedBox(height: height * 0.012),
                  const HeadingText(text: 'Phone'),
                  SizedBox(height: height * 0.007),
                  DialCodePicker(
                    initialPhone: phone,
                    onChanged: (value) => phone = value,
                  ),
                  const HeadingText(text: 'Date of Birth'),
                  SizedBox(height: height * 0.007),
                  DatePicker(controller: dateController),
                  SizedBox(height: height * 0.012),
                  const HeadingText(text: 'City/Province'),
                  SizedBox(height: height * 0.007),
                  RegionTextfield(
                    value: city,
                    onChanged: (value) => city = value,
                  ),
                  SizedBox(height: height * 0.007),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: Obx(
                      () => CustomButton(
                        textColor: Colors.white,
                        color: AppColors.forestGreen,
                        label: profileController.isSaving.value
                            ? 'Saving...'
                            : 'Save',
                        onTap: profileController.isSaving.value
                            ? null
                            : () => _save(pageController),
                      ),
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

  Future<void> _save(OnboardingController pageController) async {
    final saved = await profileController.saveProfile(
      fullName: nameController.text,
      phone: phone,
      location: city,
      dateOfBirth: dateController.text,
      imagePath: imageController.imagePath.value,
    );

    if (!saved) {
      _showSaveMessage(
        title: 'Save Failed',
        message: 'Profile could not be saved. Please try again.',
        color: Colors.red.shade600,
        icon: Icons.error_outline,
      );
      return;
    }

    imageController.clearImage();
    pageController.changePage(4);
    Get.back();
    _showSaveMessage(
      title: 'Success',
      message: 'Saved Successfully!',
      color: const Color(0xFF004D40),
      icon: Icons.check_circle_outline,
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

ImageProvider _profileImage(String imagePath, String? avatarUrl) {
  if (imagePath.isNotEmpty) {
    return FileImage(File(imagePath));
  }

  if (avatarUrl != null && avatarUrl.isNotEmpty) {
    return NetworkImage(avatarUrl);
  }

  return const AssetImage('assets/images/profile_placeholder.png');
}

void _showSaveMessage({
  required String title,
  required String message,
  required Color color,
  required IconData icon,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color,
    colorText: Colors.white,
    borderRadius: 15,
    margin: const EdgeInsets.all(15),
    duration: const Duration(seconds: 2),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    icon: Icon(icon, color: const Color(0xFFC6FF00), size: 30),
    leftBarIndicatorColor: const Color(0xFFC6FF00),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

void showImageSourceDialog(ImagePickerController controller) {
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
        mainAxisSize: MainAxisSize.min,
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
