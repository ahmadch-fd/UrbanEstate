import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/controllers/user_profile_controller.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/product_detail/product_detail_screen.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/edit_profile.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/menu_blogs/menu_blog_screen.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/widgets/name_location_column.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/widgets/profile_accounts_setting_rows.dart';
import 'package:urban_estate/view/screens/page_view/profile & setting/widgets/profile_image_row.dart';
import 'package:urban_estate/view/screens/singn_in_screen.dart';
import 'package:urban_estate/view/widgets/dialog_for_logout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final responsive = Responsive.of(context);
    final profileController = Get.put(UserProfileController(), permanent: true);
    final listingController = Get.put(
      PropertyListingController(),
      permanent: true,
    );
    profileController.loadProfile();
    listingController.fetchFeed();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: _ProfileDrawer(
          height: height,
          width: width,
          profileController: profileController,
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await profileController.loadProfile(force: true);
                          if (!context.mounted) return;
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          LucideIcons.menu,
                          color: AppColors.forestGreen,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Profile',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const ProfileImageRow(),
                SizedBox(height: height * 0.01),
                NameLocationColumn(height: height),
                SizedBox(height: responsive.space(22)),
                Obx(() {
                  final currentUserId = profileController.profile.value?.id;
                  final myProperties = listingController.postedProperties
                      .where((property) => property.ownerId == currentUserId)
                      .toList();

                  return _MyListingsSection(
                    properties: myProperties,
                    isLoading: listingController.isLoading.value,
                  );
                }),
                SizedBox(height: responsive.bottomNavSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyListingsSection extends StatelessWidget {
  const _MyListingsSection({required this.properties, required this.isLoading});

  final List<PostedProperty> properties;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.space(16),
              vertical: responsive.space(14),
            ),
            decoration: BoxDecoration(
              color: AppColors.forestGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _ProfileStat(
                  value: properties.length.toString(),
                  label: 'Listings',
                ),
                Container(
                  width: 1,
                  height: responsive.scale(34),
                  margin: EdgeInsets.symmetric(
                    horizontal: responsive.space(18),
                  ),
                  color: Colors.white.withValues(alpha: 0.22),
                ),
                const _ProfileStat(value: 'Active', label: 'Status'),
                const Spacer(),
                const Icon(
                  Icons.grid_view_rounded,
                  color: AppColors.primaryButtonColor,
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.space(18)),
          Row(
            children: [
              Text(
                'My Properties',
                style: poppinsSemiBold.copyWith(
                  color: AppColors.forestGreen,
                  fontSize: responsive.font(18),
                ),
              ),
              const Spacer(),
              Text(
                '${properties.length} posted',
                style: poppinsRegular.copyWith(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: responsive.font(12),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.space(12)),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (properties.isEmpty)
            _EmptyListingsCard(responsive: responsive)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: properties.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: responsive.space(12),
                mainAxisSpacing: responsive.space(12),
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                return _ProfilePropertyCard(
                  property: properties[index],
                  index: index,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: poppinsSemiBold.copyWith(
            color: Colors.white,
            fontSize: responsive.font(18),
          ),
        ),
        Text(
          label,
          style: poppinsRegular.copyWith(
            color: Colors.white.withValues(alpha: 0.68),
            fontSize: responsive.font(12),
          ),
        ),
      ],
    );
  }
}

class _EmptyListingsCard extends StatelessWidget {
  const _EmptyListingsCard({required this.responsive});

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.space(22)),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: responsive.scale(54),
            width: responsive.scale(54),
            decoration: const BoxDecoration(
              color: AppColors.primaryButtonColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.home, color: AppColors.forestGreen),
          ),
          SizedBox(height: responsive.space(12)),
          Text(
            'No properties posted yet',
            style: poppinsSemiBold.copyWith(
              color: AppColors.forestGreen,
              fontSize: responsive.font(15),
            ),
          ),
          SizedBox(height: responsive.space(4)),
          Text(
            'Your listings will appear here after you post them.',
            textAlign: TextAlign.center,
            style: poppinsRegular.copyWith(
              color: Colors.black.withValues(alpha: 0.55),
              fontSize: responsive.font(12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePropertyCard extends StatelessWidget {
  const _ProfilePropertyCard({required this.property, required this.index});

  final PostedProperty property;
  final int index;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return GestureDetector(
      onTap: () => Get.to(
        () => PropertyDetailsScreen(propertyIndex: index, property: property),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(child: _ProfileListingImage(property: property)),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsive.space(10),
                right: responsive.space(10),
                bottom: responsive.space(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsSemiBold.copyWith(
                        color: Colors.white,
                        fontSize: responsive.font(13),
                      ),
                    ),
                    SizedBox(height: responsive.space(2)),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property.displayPrice,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: poppinsRegular.copyWith(
                              color: AppColors.primaryButtonColor,
                              fontSize: responsive.font(12),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.collections_outlined,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: responsive.icon(15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileListingImage extends StatelessWidget {
  const _ProfileListingImage({required this.property});

  final PostedProperty property;

  @override
  Widget build(BuildContext context) {
    final imagePath = property.imagePaths.isNotEmpty
        ? property.imagePaths.first
        : property.imagePath;
    final imageUrl = property.imageUrls.isNotEmpty
        ? property.imageUrls.first
        : property.imageUrl;

    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Container(
      color: AppColors.forestGreen.withValues(alpha: 0.16),
      child: const Center(
        child: Icon(LucideIcons.home, color: AppColors.forestGreen, size: 34),
      ),
    );
  }
}

class _ProfileDrawer extends StatelessWidget {
  const _ProfileDrawer({
    required this.height,
    required this.width,
    required this.profileController,
  });

  final double height;
  final double width;
  final UserProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Menu',
                      style: poppinsSemiBold.copyWith(
                        color: AppColors.forestGreen,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
              ),
              _DrawerSection(
                title: 'Account',
                height: height,
                width: width,
                children: [
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.user,
                    text: 'Edit Profile',
                    ontap: () {
                      Get.back();
                      Get.to(() => const EditProfile());
                    },
                  ),
                  SizedBox(height: height * 0.01),
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.shieldCheck,
                    text: 'Security',
                    ontap: () => _openBlog(MenuBlog.security()),
                  ),
                  SizedBox(height: height * 0.01),
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.lock,
                    text: 'Privacy',
                    ontap: () => _openBlog(MenuBlog.privacy()),
                  ),
                  SizedBox(height: height * 0.01),
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.unlock,
                    text: 'Unlock Properties',
                    ontap: () => _openBlog(MenuBlog.unlockProperties()),
                  ),
                  SizedBox(height: height * 0.01),
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.alertTriangle,
                    text: 'Report a Problem',
                    ontap: () => _openBlog(MenuBlog.reportProblem()),
                  ),
                ],
              ),
              _DrawerSection(
                title: 'Support & Policies',
                height: height,
                width: width,
                children: [
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.helpCircle,
                    text: 'Help & Support',
                    ontap: () => _openBlog(MenuBlog.helpSupport()),
                  ),
                  SizedBox(height: height * 0.01),
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.fileText,
                    text: 'Terms & Policies',
                    ontap: () => _openBlog(MenuBlog.termsPolicies()),
                  ),
                  SizedBox(height: height * 0.01),
                  ProfileAccountsSettingRows(
                    width: width,
                    icon: LucideIcons.logOut,
                    text: 'Log Out',
                    ontap: () => _logout(profileController),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openBlog(MenuBlog blog) {
    Get.back();
    Get.to(
      () => MenuBlogScreen(
        title: blog.title,
        subtitle: blog.subtitle,
        icon: blog.icon,
        sections: blog.sections,
      ),
    );
  }

  Future<void> _logout(UserProfileController profileController) async {
    final shouldLogout = await Get.dialog<bool>(const DialogForLogout());

    if (shouldLogout != true) return;

    try {
      await AuthService.signOut();
      profileController.clearProfile();
      if (Get.isRegistered<MessageController>()) {
        Get.find<MessageController>().clearMessages();
      }
      if (Get.isRegistered<PropertyListingController>()) {
        Get.find<PropertyListingController>().clearSessionData();
      }
      if (Get.isRegistered<ImagePickerController>()) {
        Get.find<ImagePickerController>().clearImage();
      }
      Get.offAll(() => const SingnInScreen());
    } catch (error) {
      Get.snackbar(
        'Logout failed',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _DrawerSection extends StatelessWidget {
  const _DrawerSection({
    required this.title,
    required this.height,
    required this.width,
    required this.children,
  });

  final String title;
  final double height;
  final double width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              title,
              style: poppinsRegular.copyWith(
                color: AppColors.forestGreen,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(9, 12, 9, 12),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
