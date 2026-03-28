class ClientProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;

  const ClientProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileImage,
  });

  factory ClientProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ClientProfileModel(
        id: 0,
        name: '',
        email: '',
        phone: '',
        role: '',
        profileImage: '',
      );
    }

    return ClientProfileModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      phone: _asString(json['phone']),
      role: _asString(json['role']),
      profileImage: _asString(json['profile_image'] ?? json['avatar']),
    );
  }
}

String _asString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
