import 'package:get/get.dart';
import 'package:urban_estate/models/posted_property.dart';
import 'package:urban_estate/services/location_service.dart';
import 'package:urban_estate/services/property_service.dart';

class PropertyListingController extends GetxController {
  final RxList<PostedProperty> postedProperties = <PostedProperty>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedTenantType = ''.obs;
  final RxnString selectedProvince = RxnString();
  final RxnString selectedCity = RxnString();
  final RxList<String> recentlyVisitedPropertyIds = <String>[].obs;
  String? _recentHistoryUserId;

  final RxMap<String, List<String>> provinceCityOptions =
      Map<String, List<String>>.from(
        LocationService.fallbackProvinceCities,
      ).obs;

  List<String> get tenantTypeOptions => const [
    'Bachelor',
    'Family',
    'Office',
    'Sublet',
  ];

  List<String> get provinceOptions => provinceCityOptions.keys.toList();

  List<String> citiesForProvince(String? province) {
    if (province == null || province.isEmpty) return const [];
    return provinceCityOptions[province] ?? const [];
  }

  bool get hasLocationFilter =>
      (selectedProvince.value?.isNotEmpty ?? false) ||
      (selectedCity.value?.isNotEmpty ?? false);

  bool get hasActiveFilter =>
      selectedTenantType.value.isNotEmpty || hasLocationFilter;

  String get locationFilterLabel {
    final province = selectedProvince.value;
    final city = selectedCity.value;

    if ((province == null || province.isEmpty) &&
        (city == null || city.isEmpty)) {
      return '';
    }

    if (province == null || province.isEmpty) return city ?? '';
    if (city == null || city.isEmpty) return province;
    return '$province, $city';
  }

  String get activeFilterTitle {
    final parts = <String>[
      if (selectedTenantType.value.isNotEmpty) selectedTenantType.value,
      if (locationFilterLabel.isNotEmpty) locationFilterLabel,
    ];

    if (parts.isEmpty) return 'Properties';
    return '${parts.join(' in ')} Properties';
  }

  List<PostedProperty> get filteredProperties {
    final tenantFilter = selectedTenantType.value;
    final provinceFilter = selectedProvince.value?.trim().toLowerCase() ?? '';
    final cityFilter = selectedCity.value?.trim().toLowerCase() ?? '';

    if (tenantFilter.isEmpty && provinceFilter.isEmpty && cityFilter.isEmpty) {
      return postedProperties;
    }

    return postedProperties.where((property) {
      final matchesTenant =
          tenantFilter.isEmpty || property.tenantType == tenantFilter;
      final matchesProvince =
          provinceFilter.isEmpty ||
          property.province.trim().toLowerCase() == provinceFilter;
      final matchesCity =
          cityFilter.isEmpty ||
          property.city.trim().toLowerCase() == cityFilter;

      return matchesTenant && matchesProvince && matchesCity;
    }).toList();
  }

  List<PostedProperty> get recentlyVisitedProperties {
    final propertiesById = {
      for (final property in filteredProperties) property.id: property,
    };

    return recentlyVisitedPropertyIds
        .map((id) => propertiesById[id])
        .whereType<PostedProperty>()
        .toList();
  }

  void setTenantTypeFilter(String tenantType) {
    selectedTenantType.value = selectedTenantType.value == tenantType
        ? ''
        : tenantType;
  }

  void clearTenantTypeFilter() {
    selectedTenantType.value = '';
  }

  void applyLocationFilter({String? province, String? city}) {
    selectedProvince.value = province;
    selectedCity.value = city;
  }

  void clearLocationFilter() {
    selectedProvince.value = null;
    selectedCity.value = null;
  }

  void clearAllFilters() {
    selectedTenantType.value = '';
    clearLocationFilter();
  }

  Future<void> loadLocationOptions() async {
    final locations = await LocationService.provinceCities();
    provinceCityOptions.assignAll(locations);
    if (!provinceCityOptions.containsKey(selectedProvince.value)) {
      clearLocationFilter();
    } else if (!citiesForProvince(
      selectedProvince.value,
    ).contains(selectedCity.value)) {
      selectedCity.value = null;
    }
  }

  Future<void> loadRecentlyVisitedProperties({bool force = false}) async {
    final userId = PropertyService.currentUserId;
    if (!force && _recentHistoryUserId == userId) return;

    _recentHistoryUserId = userId;

    if (userId == null) {
      recentlyVisitedPropertyIds.clear();
      return;
    }

    final ids = await PropertyService.fetchRecentlyViewedPropertyIds();
    recentlyVisitedPropertyIds.assignAll(ids);
  }

  void markPropertyVisited(PostedProperty? property) {
    if (property == null || property.id.isEmpty) return;

    recentlyVisitedPropertyIds.remove(property.id);
    recentlyVisitedPropertyIds.insert(0, property.id);

    if (recentlyVisitedPropertyIds.length > 20) {
      recentlyVisitedPropertyIds.removeRange(
        20,
        recentlyVisitedPropertyIds.length,
      );
    }

    PropertyService.markPropertyViewed(property.id).catchError((_) {});
  }

  void clearSessionData() {
    clearAllFilters();
    recentlyVisitedPropertyIds.clear();
    _recentHistoryUserId = null;
  }

  @override
  void onInit() {
    super.onInit();
    loadLocationOptions();
    fetchFeed();
  }

  Future<void> fetchFeed() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final properties = await PropertyService.fetchFeed();
      postedProperties.assignAll(properties);
      await loadRecentlyVisitedProperties(force: true);
      final availableIds = properties.map((property) => property.id).toSet();
      recentlyVisitedPropertyIds.removeWhere(
        (propertyId) => !availableIds.contains(propertyId),
      );
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProperty(PostedProperty property) async {
    final createdProperty = await PropertyService.createProperty(property);
    postedProperties.insert(0, createdProperty);
  }

  Future<void> deleteProperty(String id) async {
    await PropertyService.deleteProperty(id);
    postedProperties.removeWhere((property) => property.id == id);
    recentlyVisitedPropertyIds.remove(id);
  }
}
