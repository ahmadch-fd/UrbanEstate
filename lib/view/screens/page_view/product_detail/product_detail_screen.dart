import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/controllers/favorite_controller.dart';
import 'package:urban_estate/controllers/message_controller.dart';
import 'package:urban_estate/controllers/page_view_controller.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/services/auth_service.dart';
import 'package:urban_estate/utils/responsive.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({
    super.key,
    this.propertyIndex = 0,
    this.property,
  });

  final int propertyIndex;
  final PostedProperty? property;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final FavoriteController favoriteController = Get.put(
    FavoriteController(),
    permanent: true,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(
        PropertyListingController(),
        permanent: true,
      ).markPropertyVisited(widget.property);
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final Color forestGreen = const Color(0xFF004D40);
    final Color limeGreen = const Color(0xFFC6FF00);

    return SafeArea(
      child: Scaffold(
        backgroundColor: forestGreen,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Image Section
                  _buildHeaderImage(),

                  // 2. Details Content
                  Padding(
                    padding: EdgeInsets.all(responsive.pagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndLocation(limeGreen),
                        SizedBox(height: responsive.space(20)),
                        _buildOwnerSection(),
                        _buildOwnerDeleteButton(),
                        SizedBox(height: responsive.space(20)),
                        _buildAmenitiesRow(),
                        SizedBox(height: responsive.space(20)),
                        _buildPriceSummary(limeGreen),
                        SizedBox(height: responsive.space(18)),
                        _buildPropertyDetailsPanel(limeGreen),
                        SizedBox(height: responsive.space(18)),
                        _buildFeaturesPanel(limeGreen),
                        SizedBox(height: responsive.space(18)),
                        _buildLocationPanel(limeGreen),
                        SizedBox(height: responsive.space(18)),
                        _buildDescription(),
                        SizedBox(height: responsive.bottomNavSpace),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 4. Floating Top Buttons
            _buildFloatingTopButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    final responsive = Responsive.of(context);
    final List<String> imageUrls = [
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=800',
      'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1400',
      'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=1400',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1400',
    ];
    final propertyImagePaths = widget.property?.imagePaths ?? const <String>[];
    final propertyImageUrls = widget.property?.imageUrls ?? const <String>[];
    final postedImagePath = widget.property?.imagePath;
    final postedImageUrl = widget.property?.imageUrl;
    final galleryCount = propertyImageUrls.isNotEmpty
        ? propertyImageUrls.length
        : propertyImagePaths.isNotEmpty
        ? propertyImagePaths.length
        : postedImagePath == null && postedImageUrl == null
        ? imageUrls.length
        : 1;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // SWIPEABLE IMAGE SECTION
        SizedBox(
          height: responsive.detailHeaderHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: galleryCount,
            itemBuilder: (context, index) {
              if (propertyImageUrls.isNotEmpty) {
                return Image.network(
                  propertyImageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    imageUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }

              if (propertyImagePaths.isNotEmpty) {
                return Image.file(
                  File(propertyImagePaths[index]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    imageUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }

              if (postedImageUrl != null && postedImageUrl.isNotEmpty) {
                return Image.network(
                  postedImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    imageUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }

              if (postedImagePath != null && postedImagePath.isNotEmpty) {
                return Image.file(
                  File(postedImagePath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    imageUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }

              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                // Adding an error builder to prevent the 404 issue we!
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 50)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // The image is fully loaded, return it!
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFFC6FF00),
                      // Using your limeGreen cirlcular indictor color
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ),

        // INDICATOR DOTS
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              galleryCount,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                // Logical Fix: Check index against _currentPage
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFFC6FF00) // Active color
                      : Colors.white70, // Inactive color
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndLocation(Color lime) {
    final responsive = Responsive.of(context);
    final property = widget.property;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property?.title ?? 'Prestige Grand Apartment',
          style: GoogleFonts.poppins(
            fontSize: responsive.font(26),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: responsive.space(10)),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            _iconText(
              Icons.location_on,
              property?.displayLocation ?? 'San Francisco, CA',
              lime,
            ),
            _iconText(
              Icons.square_foot,
              property?.areaSqft.isEmpty ?? true
                  ? '3480 Sq. Ft'
                  : '${property!.areaSqft} Sq. Ft',
              lime,
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconText(IconData icon, String label, Color color) {
    final responsive = Responsive.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: responsive.icon(16)),
        SizedBox(width: responsive.space(4)),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: responsive.font(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    final responsive = Responsive.of(context);
    final description = widget.property?.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description == null || description.isEmpty
              ? 'Welcome to Your New Home! This Modern and Spacious 2-Bedroom apartment is located in the heart of San Francisco...'
              : description,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            height: 1.5,
            fontSize: responsive.font(14),
          ),
        ),
        if (description == null || description.length > 120)
          Text(
            'Read More..',
            style: TextStyle(
              color: const Color(0xFFC6FF00),
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildAmenitiesRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _amenityChip(
            Icons.home_work,
            widget.property?.propertyType.isEmpty ?? true
                ? 'Apartment'
                : widget.property!.propertyType,
          ),
          _amenityChip(
            Icons.square_foot,
            widget.property?.areaSqft.isEmpty ?? true
                ? '3480 Sq. Ft'
                : '${widget.property!.areaSqft} Sq. Ft',
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(IconData icon, String label) {
    final responsive = Responsive.of(context);
    return Container(
      margin: EdgeInsets.only(right: responsive.space(12)),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.space(16),
        vertical: responsive.space(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC6FF00), size: responsive.icon(20)),
          SizedBox(width: responsive.space(8)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.font(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerSection() {
    final responsive = Responsive.of(context);
    final property = widget.property;
    final isOwner =
        property != null && AuthService.currentUser?.id == property.ownerId;

    return Row(
      children: [
        CircleAvatar(
          radius: responsive.icon(25),
          backgroundImage:
              property?.ownerAvatarUrl != null &&
                  property!.ownerAvatarUrl!.isNotEmpty
              ? NetworkImage(property.ownerAvatarUrl!)
              : const NetworkImage('https://i.pravatar.cc/150?u=owner'),
        ),
        SizedBox(width: responsive.space(12)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property?.ownerName.isEmpty ?? true
                  ? 'William Henry'
                  : property!.ownerName,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              property?.ownerPhone.isEmpty ?? true
                  ? 'Owner'
                  : property!.ownerPhone,
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
        if (!isOwner) ...[
          const Spacer(),
          circleIconButton(
            Icons.chat_bubble,
            ontap: () => _openOwnerChat(property),
          ),
        ],
      ],
    );
  }

  Future<void> _openOwnerChat(PostedProperty? property) async {
    if (property == null) return;

    await Get.put(
      MessageController(),
      permanent: true,
    ).openThreadForProperty(property);

    Get.back();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<OnboardingController>()) {
        Get.find<OnboardingController>().changePage(3);
      }
    });
  }

  Widget _buildOwnerDeleteButton() {
    final responsive = Responsive.of(context);
    final listingController = Get.put(
      PropertyListingController(),
      permanent: true,
    );
    final property = widget.property;
    final canDelete =
        property != null && AuthService.currentUser?.id == property.ownerId;

    if (!canDelete) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: responsive.space(14)),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            await listingController.deleteProperty(property.id);
            Get.back();
          },
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete My Post'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red.shade200,
            side: BorderSide(color: Colors.red.shade200),
            padding: EdgeInsets.symmetric(vertical: responsive.space(12)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary(Color lime) {
    final responsive = Responsive.of(context);
    final property = widget.property;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.space(18)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryPrice(
              'Asked Price',
              property?.displayPrice ?? 'Rs. 4,659',
            ),
          ),
          Container(
            width: 1,
            height: responsive.scale(52),
            color: Colors.white.withValues(alpha: 0.15),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: responsive.space(16)),
              child: _summaryPrice(
                'Predicted Price',
                property?.displayPredictedPrice ?? '\$4,659',
                highlight: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryPrice(String label, String value, {bool highlight = false}) {
    final responsive = Responsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: responsive.font(12),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: GoogleFonts.poppins(
                color: highlight ? const Color(0xFFC6FF00) : Colors.white,
                fontSize: responsive.font(20),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyDetailsPanel(Color lime) {
    final property = widget.property;
    final items = [
      _DetailItem(
        Icons.groups,
        'Property For',
        property?.tenantType.isEmpty ?? true
            ? 'Not specified'
            : property!.tenantType,
      ),
      _DetailItem(Icons.flag, 'Purpose', property?.purpose ?? 'For Rent'),
      _DetailItem(
        Icons.payments,
        'Price For',
        property?.displayPriceFor ?? 'Monthly Rent',
      ),
      _DetailItem(
        Icons.king_bed,
        'Bedrooms',
        property?.bedrooms.isEmpty ?? true ? '2' : property!.bedrooms,
      ),
      _DetailItem(
        Icons.bathtub,
        'Bathrooms',
        property?.bathrooms.isEmpty ?? true ? '3' : property!.bathrooms,
      ),
      _DetailItem(
        Icons.calendar_month,
        'Available',
        property?.availableFrom.isEmpty ?? true
            ? 'Immediately'
            : property!.availableFrom,
      ),
      _DetailItem(
        Icons.stairs,
        'Floor',
        property?.floorNo.isEmpty ?? true ? 'Ground' : property!.floorNo,
      ),
      _DetailItem(
        Icons.balcony,
        'Balcony',
        property?.balcony.isEmpty ?? true ? 'Not specified' : property!.balcony,
      ),
      _DetailItem(
        Icons.history,
        'Age',
        property?.ageOfHouse.isEmpty ?? true
            ? 'Not specified'
            : '${property!.ageOfHouse} years',
      ),
    ];

    return _infoPanel(
      title: 'Property Details',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((item) => _detailTile(item, lime)).toList(),
      ),
    );
  }

  Widget _buildFeaturesPanel(Color lime) {
    final property = widget.property;
    final bills = property?.includedBills ?? const <String>[];
    final features = property?.features ?? const <String>[];

    return _infoPanel(
      title: 'Features & Bills',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chipWrap(
            bills.isEmpty ? ['No included bills selected'] : bills,
            lime,
            Icons.receipt_long,
          ),
          SizedBox(height: Responsive.of(context).space(12)),
          _chipWrap(
            features.isEmpty ? ['No extra features selected'] : features,
            lime,
            Icons.auto_awesome,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPanel(Color lime) {
    final property = widget.property;
    final hasCoordinates =
        property != null &&
        property.latitude.isNotEmpty &&
        property.longitude.isNotEmpty;
    final items = [
      _DetailItem(
        Icons.location_city,
        'City',
        property?.city.isEmpty ?? true ? 'San Francisco' : property!.city,
      ),
      _DetailItem(
        Icons.map,
        'Province',
        property?.province.isEmpty ?? true ? 'California' : property!.province,
      ),
      _DetailItem(
        Icons.place,
        'Address',
        property?.location.isEmpty ?? true
            ? 'San Francisco, CA'
            : property!.location,
      ),
      _DetailItem(
        Icons.my_location,
        'Coordinates',
        hasCoordinates
            ? '${property.latitude}, ${property.longitude}'
            : 'Not added',
      ),
    ];

    return _infoPanel(
      title: 'Location',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((item) => _detailTile(item, lime)).toList(),
      ),
    );
  }

  Widget _infoPanel({required String title, required Widget child}) {
    final responsive = Responsive.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.space(16)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: responsive.font(16),
            ),
          ),
          SizedBox(height: responsive.space(12)),
          child,
        ],
      ),
    );
  }

  Widget _detailTile(_DetailItem item, Color lime) {
    final responsive = Responsive.of(context);
    return Container(
      width: (responsive.width - responsive.pagePadding * 2 - 42) / 2,
      padding: EdgeInsets.all(responsive.space(12)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: lime, size: responsive.icon(19)),
          SizedBox(height: responsive.space(8)),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: responsive.font(11),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: responsive.font(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipWrap(List<String> values, Color lime, IconData icon) {
    final responsive = Responsive.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.space(12),
                vertical: responsive.space(9),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: lime, size: responsive.icon(15)),
                  SizedBox(width: responsive.space(6)),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: responsive.font(12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFloatingTopButtons() {
    final responsive = Responsive.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.pagePadding,
          vertical: responsive.space(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            circleIconButton(
              ontap: () {
                Get.back();
              },
              Icons.arrow_back_ios_new,
              bgColor: Colors.white.withValues(alpha: 0.3),
            ),
            Obx(() {
              final bool isFavorite = favoriteController.isFavorite(
                widget.property,
              );

              return circleIconButton(
                ontap: () {
                  favoriteController.toggleFavorite(widget.property);
                },
                isFavorite ? Icons.favorite : Icons.favorite_border,
                bgColor: Colors.white.withValues(alpha: 0.3),
                iconColor: isFavorite ? const Color(0xFFE53935) : Colors.white,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget circleIconButton(
    IconData icon, {
    Color bgColor = const Color(0xFF004D40),
    Color iconColor = Colors.white,
    required VoidCallback ontap,
  }) {
    final responsive = Responsive.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ontap,
      child: Container(
        width: responsive.icon(46),
        height: responsive.icon(46),
        padding: EdgeInsets.all(responsive.space(10)),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: iconColor, size: responsive.icon(22)),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _DetailItem {
  const _DetailItem(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}
