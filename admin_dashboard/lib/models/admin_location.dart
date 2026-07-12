class AdminLocation {
  const AdminLocation({
    required this.id,
    required this.province,
    required this.city,
    required this.isActive,
  });

  final String id;
  final String province;
  final String city;
  final bool isActive;

  factory AdminLocation.fromMap(Map<String, dynamic> map) {
    return AdminLocation(
      id: map['id']?.toString() ?? '',
      province: map['province']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      isActive: map['is_active'] == true,
    );
  }
}
