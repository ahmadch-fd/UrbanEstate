import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/product_detail/product_detail_screen.dart';

// class BestHousesCards extends StatelessWidget {
//   const BestHousesCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;
//     return SizedBox(
//       height: height * 0.4,
//       child: ListView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 13),
//             child: Stack(
//               children: [

//                 Container(
//                   height: height * 0.34,
//                   width: width * 0.92,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: const Color.fromARGB(255, 150, 93, 93),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
class BestForYouCard extends StatelessWidget {
  const BestForYouCard({
    super.key,
    required this.index,
    this.compact = false,
    this.property,
  });

  final int index;
  final bool compact;
  final PostedProperty? property;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final List<String> networkImageList = [
      'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=800',
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=800',
      'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=800',
    ];
    final List<String> houseType = [
      'Dreamsville House',
      'Sunset Villa',
      'Oceanview Apartment',
    ];
    final List<String> housePrices = ['\$3,850', '\$4,200', '\$2,950'];
    final List<String> houseLocations = [
      'Jl. Sultan Iskandar Muda',
      'Jl. Pantai Indah Kapuk',
      'Jl. Kemang Raya',
    ];
    final int propertyIndex = index % networkImageList.length;
    final title = property?.title ?? houseType[propertyIndex];
    final price = property?.displayPrice ?? housePrices[propertyIndex];
    final location = property?.displayLocation ?? houseLocations[propertyIndex];

    return Container(
      margin: compact
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: EdgeInsets.all(responsive.space(compact ? 10 : 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _PropertyImage(
              imagePath: property?.imagePaths.isNotEmpty ?? false
                  ? property!.imagePaths.first
                  : property?.imagePath,
              imageUrl: property?.imageUrls.isNotEmpty ?? false
                  ? property!.imageUrls.first
                  : property?.imageUrl,
              fallbackUrl: networkImageList[propertyIndex],
              height: compact
                  ? responsive.compactCardImageHeight
                  : responsive.largeCardImageHeight,
            ),
          ),
          SizedBox(height: responsive.space(compact ? 7 : 12)),
          compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: responsive.font(12.5),
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.font(13.5),
                        color: const Color(0xFF004D40),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.font(16),
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.space(10)),
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.font(16),
                        color: const Color(0xFF004D40),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: responsive.space(compact ? 4 : 0)),
          compact
              ? Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: responsive.font(10.5),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: responsive.font(12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.to(
                        () => PropertyDetailsScreen(
                          propertyIndex: propertyIndex,
                          property: property,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC6FF00),
                        foregroundColor: const Color(0xFF004D40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('See Details'),
                    ),
                  ],
                ),
          if (compact) ...[
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: responsive.buttonHeight * 0.62,
              child: ElevatedButton(
                onPressed: () => Get.to(
                  () => PropertyDetailsScreen(
                    propertyIndex: propertyIndex,
                    property: property,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6FF00),
                  foregroundColor: const Color(0xFF004D40),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'See Details',
                  style: GoogleFonts.poppins(
                    fontSize: responsive.font(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({
    required this.imagePath,
    required this.imageUrl,
    required this.fallbackUrl,
    required this.height,
  });

  final String? imagePath;
  final String? imageUrl;
  final String fallbackUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.file(
        File(imagePath!),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _NetworkFallback(
          fallbackUrl: fallbackUrl,
          height: height,
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _NetworkFallback(
          fallbackUrl: fallbackUrl,
          height: height,
        ),
      );
    }

    return _NetworkFallback(fallbackUrl: fallbackUrl, height: height);
  }
}

class _NetworkFallback extends StatelessWidget {
  const _NetworkFallback({required this.fallbackUrl, required this.height});

  final String fallbackUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      fallbackUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
