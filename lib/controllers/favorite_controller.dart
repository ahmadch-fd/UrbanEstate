import 'package:get/get.dart';
import 'package:urban_estate/models/posted_property.dart';

class FavoriteController extends GetxController {
  final RxMap<String, PostedProperty> favoriteProperties =
      <String, PostedProperty>{}.obs;

  bool isFavorite(PostedProperty? property) {
    return property != null && favoriteProperties.containsKey(property.id);
  }

  void toggleFavorite(PostedProperty? property) {
    if (property == null) return;

    if (isFavorite(property)) {
      favoriteProperties.remove(property.id);
    } else {
      favoriteProperties[property.id] = property;
    }
  }
}
