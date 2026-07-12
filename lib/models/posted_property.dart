class PostedProperty {
  const PostedProperty({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.title,
    required this.location,
    required this.city,
    required this.province,
    required this.tenantType,
    required this.propertyType,
    required this.bedrooms,
    required this.bathrooms,
    required this.availableFrom,
    required this.balcony,
    required this.floorNo,
    required this.areaSqft,
    required this.ageOfHouse,
    required this.price,
    required this.priceFor,
    required this.purpose,
    required this.description,
    required this.features,
    required this.includedBills,
    required this.latitude,
    required this.longitude,
    this.predictedPrice,
    this.ownerAvatarUrl,
    this.imagePath,
    this.imageUrl,
    this.imagePaths = const [],
    this.imageUrls = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String title;
  final String location;
  final String city;
  final String province;
  final String tenantType;
  final String propertyType;
  final String bedrooms;
  final String bathrooms;
  final String availableFrom;
  final String balcony;
  final String floorNo;
  final String areaSqft;
  final String ageOfHouse;
  final String price;
  final String priceFor;
  final String purpose;
  final String description;
  final List<String> features;
  final List<String> includedBills;
  final String latitude;
  final String longitude;
  final String? predictedPrice;
  final String? ownerAvatarUrl;
  final String? imagePath;
  final String? imageUrl;
  final List<String> imagePaths;
  final List<String> imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayLocation {
    if (location.isEmpty && city.isEmpty) return province;
    if (city.isEmpty) return location;
    if (location.isEmpty) return province.isEmpty ? city : '$city, $province';
    return province.isEmpty ? '$location, $city' : '$location, $city';
  }

  String get displayPrice => price.isEmpty ? 'Contact' : 'Rs. ${_formatAmount(price)}';

  String get displayPredictedPrice {
    if (predictedPrice != null &&
        predictedPrice!.isNotEmpty &&
        !_isLegacyCopiedPrediction) {
      return 'Rs. ${_formatAmount(predictedPrice!)}';
    }
    return 'Not predicted yet';
  }

  bool get _isLegacyCopiedPrediction {
    final predicted = double.tryParse(predictedPrice ?? '');
    final asked = double.tryParse(price);
    return predicted != null && asked != null && predicted == asked;
  }

  String _formatAmount(String value) {
    final amount = double.tryParse(value);
    if (amount == null) return value;

    return amount.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  String get displayPriceFor {
    if (purpose == 'For Sale') return 'For Sale';
    return priceFor.isEmpty ? 'Monthly Rent' : priceFor;
  }

  factory PostedProperty.fromMap(Map<String, dynamic> map) {
    final owner = map['profiles'] is Map<String, dynamic>
        ? map['profiles'] as Map<String, dynamic>
        : <String, dynamic>{};

    return PostedProperty(
      id: map['id']?.toString() ?? '',
      ownerId: map['owner_id']?.toString() ?? '',
      ownerName: owner['full_name']?.toString() ?? 'Owner',
      ownerPhone: owner['phone']?.toString() ?? '',
      ownerAvatarUrl: owner['avatar_url']?.toString(),
      title: map['title']?.toString() ?? 'New Property',
      location: map['location']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      province: map['province']?.toString() ?? '',
      tenantType: map['tenant_type']?.toString() ?? '',
      propertyType: map['property_type']?.toString() ?? '',
      bedrooms: map['bedrooms']?.toString() ?? '',
      bathrooms: map['bathrooms']?.toString() ?? '',
      availableFrom: map['available_from']?.toString() ?? '',
      balcony: map['balcony']?.toString() ?? '',
      floorNo: map['floor_no']?.toString() ?? '',
      areaSqft: map['area_sqft']?.toString() ?? '',
      ageOfHouse: map['age_of_house']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      predictedPrice: map['predicted_price']?.toString(),
      priceFor: map['price_for']?.toString() ?? '',
      purpose: map['purpose']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      features: List<String>.from(map['features'] ?? const []),
      includedBills: List<String>.from(map['included_bills'] ?? const []),
      latitude: map['latitude']?.toString() ?? '',
      longitude: map['longitude']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
      imageUrls: List<String>.from(map['image_urls'] ?? const []),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(map['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'owner_id': ownerId,
      'title': title,
      'location': location,
      'city': city,
      'province': province,
      'tenant_type': tenantType,
      'property_type': propertyType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'available_from': availableFrom,
      'balcony': balcony,
      'floor_no': floorNo,
      'area_sqft': areaSqft,
      'age_of_house': ageOfHouse,
      'price': price,
      'predicted_price': predictedPrice,
      'price_for': priceFor,
      'purpose': purpose,
      'description': description,
      'features': features,
      'included_bills': includedBills,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'image_urls': imageUrls,
    };
  }
}
