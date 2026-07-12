class AdminProperty {
  const AdminProperty({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.city,
    required this.province,
    required this.price,
    required this.purpose,
    this.createdAt,
  });

  final String id;
  final String title;
  final String ownerName;
  final String city;
  final String province;
  final String price;
  final String purpose;
  final DateTime? createdAt;

  factory AdminProperty.fromMap(Map<String, dynamic> map) {
    final owner = map['profiles'] is Map<String, dynamic>
        ? map['profiles'] as Map<String, dynamic>
        : <String, dynamic>{};

    return AdminProperty(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Property',
      ownerName: owner['full_name']?.toString() ?? 'Owner',
      city: map['city']?.toString() ?? '',
      province: map['province']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      purpose: map['purpose']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
    );
  }
}
