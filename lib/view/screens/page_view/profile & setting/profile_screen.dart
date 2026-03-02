import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/edit_profile.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/widgets/name_location_column.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/widgets/profile_accounts_setting_rows.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/widgets/profile_image_row.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
  //  final ImagePickerController imagePickerController = Get.put<ImagePickerController>(ImagePickerController());
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              ProfileImageRow(),
              SizedBox(height: height * 0.01),
              NameLocationColumn(height: height),
              SizedBox(height: height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Account',
                      style: poppinsRegular.copyWith(
                        color: AppColors.forestGreen,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: height * 0.29,
                      width: width * 0.93,
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 9),
                        child: Column(
                          children: [
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.user,
                              text: 'Edit Profile',
                              ontap: () {
                                Get.to(EditProfile());
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => EditProfile(),
                                //   ),
                                // );
                              },
                            ),
                            SizedBox(height: height * 0.01),
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.shieldCheck,
                              text: 'Security',
                              ontap: () {},
                            ),
                            SizedBox(height: height * 0.01),
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.bell,
                              text: 'Notifications',
                              ontap: () {},
                            ),
                            SizedBox(height: height * 0.01),
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.lock,
                              text: 'Privacy',
                              ontap: () {},
                            ),
                            SizedBox(height: height * 0.01),
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.unlock,
                              text: 'Unlock Properties',
                              ontap: () {},
                            ),
                            SizedBox(height: height * 0.01),
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.alertTriangle,
                              text: 'Repoert a Problem',
                              ontap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Support & Policies',
                      style: poppinsRegular.copyWith(
                        color: AppColors.forestGreen,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: height * 0.11,
                      width: width * 0.93,
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 9),
                        child: Column(
                          children: [
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.helpCircle,
                              text: 'Help & Support',
                              ontap: () {},
                            ),
                            SizedBox(height: height * 0.01),
                            ProfileAccountsSettingRows(
                              width: width,
                              icon: LucideIcons.fileText,
                              text: 'Terms & Policies',
                              ontap: () {},
                            ),
                          ],
                        ),
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
}
