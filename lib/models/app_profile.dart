class AppProfile {
  const AppProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.role,
    this.dateOfBirth,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String role;
  final String? dateOfBirth;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isSuperAdmin {
    const adminEmails = {'ahmadbilal01142@gmail.com'};
    return role == 'superadmin' || adminEmails.contains(email.toLowerCase());
  }

  factory AppProfile.fromMap(Map<String, dynamic> map) {
    return AppProfile(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
      dateOfBirth: map['date_of_birth']?.toString(),
      avatarUrl: map['avatar_url']?.toString(),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(map['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'role': role,
      'date_of_birth': dateOfBirth,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AppProfile withAuthEmailFallback(String? authEmail) {
    final fallbackEmail = authEmail?.trim() ?? '';
    if (email.isNotEmpty || fallbackEmail.isEmpty) return this;

    return AppProfile(
      id: id,
      fullName: fullName,
      email: fallbackEmail,
      phone: phone,
      location: location,
      role: role,
      dateOfBirth: dateOfBirth,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
