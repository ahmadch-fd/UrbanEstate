class AdminProfile {
  const AdminProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final DateTime? createdAt;

  bool get isSuperAdmin {
    const adminEmails = {'ahmadbilal01142@gmail.com'};
    return role == 'superadmin' || adminEmails.contains(email.toLowerCase());
  }

  AdminProfile copyWith({String? email}) {
    return AdminProfile(
      id: id,
      fullName: fullName,
      email: email ?? this.email,
      phone: phone,
      role: role,
      createdAt: createdAt,
    );
  }

  factory AdminProfile.fromMap(Map<String, dynamic> map) {
    return AdminProfile(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
    );
  }
}
