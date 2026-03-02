import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_estate/utils/dimensions.dart';

class AppConstants {
  static const String dreamhouse = 'Find Your Dream House';
  static const String hintTextForSearch = 'Search';
  static const String categories = 'Category';
  static const String products = 'Products';
  static const String cartKey = 'cart_items';
}

final poppinsLite = GoogleFonts.poppins(
  fontSize: Dimensions.fontSizeSmall, // 12 for subtle/light text
  fontWeight: FontWeight.w300,
);

final poppinsRegular = GoogleFonts.poppins(
  fontSize: Dimensions.fontSizeDefault, // 14 for standard body text
  fontWeight: FontWeight.w400, // Standard "regular" weight
);

final poppinsSemiBold = GoogleFonts.poppins(
  fontSize: Dimensions.fontSizeLarge, // 18 for emphasized text
  fontWeight: FontWeight.w600,
);

final poppinsBold = GoogleFonts.poppins(
  fontSize: Dimensions.fontSizeExtraLarge, // 22 for headings
  fontWeight: FontWeight.w700,
);
