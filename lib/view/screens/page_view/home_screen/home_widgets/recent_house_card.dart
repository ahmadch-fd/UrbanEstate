import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/product_detail/product_detail_screen.dart';

class RecentHouseCard extends StatelessWidget {
  const RecentHouseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final fallbackImageUrls = [
      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
      'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    ];
    final listingController = Get.put(
      PropertyListingController(),
      permanent: true,
    );

    return Obx(() {
      final recentProperties = listingController.recentlyVisitedProperties;

      if (recentProperties.isEmpty) {
        return Container(
          height: responsive.scale(116),
          margin: EdgeInsets.symmetric(horizontal: responsive.pagePadding),
          padding: EdgeInsets.all(responsive.space(16)),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                height: responsive.icon(44),
                width: responsive.icon(44),
                decoration: BoxDecoration(
                  color: const Color(0xFFC6FF00).withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  color: const Color(0xFFC6FF00),
                  size: responsive.icon(24),
                ),
              ),
              SizedBox(width: responsive.space(12)),
              Expanded(
                child: Text(
                  'Visited properties will appear here',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: responsive.font(13),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return SizedBox(
        height: responsive.scale(190),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recentProperties.length,
          itemBuilder: (context, index) {
            final property = recentProperties[index];
            final fallbackIndex = index % fallbackImageUrls.length;

            return Padding(
              padding: index == 0
                  ? const EdgeInsets.only(left: 8.0)
                  : const EdgeInsets.only(left: 0.0),
              child: Container(
                width: responsive.width * (responsive.isTablet ? 0.46 : 0.8),
                height: responsive.scale(165),
                margin: EdgeInsets.only(right: responsive.space(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _recentImage(
                        property.imagePaths.isNotEmpty
                            ? property.imagePaths.first
                            : property.imagePath,
                        property.imageUrls.isNotEmpty
                            ? property.imageUrls.first
                            : property.imageUrl,
                        fallbackImageUrls[fallbackIndex],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          PropertyDetailsScreen(
                            propertyIndex: index,
                            property: property,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(responsive.space(16)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  property.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: responsive.font(16),
                                  ),
                                ),
                              ),
                              SizedBox(width: responsive.space(10)),
                              Text(
                                property.displayPrice,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.font(16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  property.displayLocation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: responsive.font(12),
                                  ),
                                ),
                              ),
                              SizedBox(width: responsive.space(10)),
                              Text(
                                property.displayPriceFor,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: responsive.font(10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _recentImage(String? imagePath, String? imageUrl, String fallbackUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.network(
          fallbackUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.network(
      fallbackUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
