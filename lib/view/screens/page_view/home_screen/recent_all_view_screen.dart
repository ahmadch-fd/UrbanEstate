import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/property_listing_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/best_houses_cards.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/property_location_filter_sheet.dart';
import 'package:urban_estate/view/widgets/search_text_field.dart';

class RecentAllview extends StatelessWidget {
  const RecentAllview({super.key, this.recentOnly = false});

  final bool recentOnly;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final listingController = Get.put(
      PropertyListingController(),
      permanent: true,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.forestGreen,
        appBar: AppBar(
          backgroundColor: AppColors.forestGreen,
          elevation: 0,
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          title: Text(
            recentOnly ? 'Recent Properties' : 'All Properties',
            style: poppinsSemiBold.copyWith(
              color: Colors.white,
              fontSize: responsive.font(18),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  responsive.pagePadding,
                  responsive.space(8),
                  responsive.pagePadding,
                  responsive.space(12),
                ),
                child: Row(
                  children: [
                    const Expanded(child: SearchTextField(text: 'Search Home')),
                    SizedBox(width: responsive.space(12)),
                    InkWell(
                      onTap: () => showPropertyLocationFilterSheet(
                        context: context,
                        controller: listingController,
                        responsive: responsive,
                      ),
                      customBorder: const CircleBorder(),
                      child: CircleAvatar(
                        radius: responsive.icon(24),
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.filter_list,
                          color: AppColors.mainTextColor,
                          size: responsive.icon(28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Padding(
                  padding: EdgeInsets.fromLTRB(
                    responsive.pagePadding,
                    0,
                    responsive.pagePadding,
                    responsive.space(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${(recentOnly ? listingController.recentlyVisitedProperties : listingController.filteredProperties).length} Results',
                      style: poppinsRegular.copyWith(
                        color: Colors.white,
                        fontSize: responsive.font(15),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final postedProperties = recentOnly
                      ? listingController.recentlyVisitedProperties
                      : listingController.filteredProperties;

                  if (postedProperties.isEmpty) {
                    return Center(
                      child: Text(
                        recentOnly
                            ? 'No visited properties yet'
                            : listingController.hasActiveFilter
                            ? 'No properties match this filter'
                            : 'No posted properties yet',
                        style: poppinsRegular.copyWith(
                          color: Colors.white,
                          fontSize: responsive.font(15),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      responsive.pagePadding,
                      responsive.space(8),
                      responsive.pagePadding,
                      responsive.space(24),
                    ),
                    itemCount: postedProperties.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsive.propertyGridColumns,
                      mainAxisSpacing: responsive.propertyGridSpacing,
                      crossAxisSpacing: responsive.propertyGridSpacing,
                      childAspectRatio: responsive.propertyGridRatio,
                    ),
                    itemBuilder: (context, index) {
                      return BestForYouCard(
                        index: index,
                        compact: true,
                        property: postedProperties[index],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
