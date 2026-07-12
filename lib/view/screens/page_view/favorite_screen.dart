import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/favorite_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/home_widgets/best_houses_cards.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final FavoriteController favoriteController = Get.put(
      FavoriteController(),
      permanent: true,
    );

    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            responsive.pagePadding,
            responsive.pagePadding,
            responsive.pagePadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Favorites',
                  style: poppinsSemiBold.copyWith(
                    color: Colors.white,
                    fontSize: responsive.font(20),
                  ),
                ),
              ),
              SizedBox(height: responsive.space(18)),
              Expanded(
                child: Obx(() {
                  final favoriteProperties = favoriteController
                      .favoriteProperties
                      .values
                      .toList();

                  if (favoriteProperties.isEmpty) {
                    return Center(
                      child: Text(
                        'No favorite properties yet',
                        style: poppinsRegular.copyWith(
                          color: Colors.white,
                          fontSize: responsive.font(15),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.only(bottom: responsive.bottomNavSpace),
                    itemCount: favoriteProperties.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: responsive.propertyGridColumns,
                          mainAxisSpacing: responsive.propertyGridSpacing,
                          crossAxisSpacing: responsive.propertyGridSpacing,
                          childAspectRatio: responsive.propertyGridRatio,
                        ),
                    itemBuilder: (context, index) {
                      return BestForYouCard(
                        index: index,
                        compact: true,
                        property: favoriteProperties[index],
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
