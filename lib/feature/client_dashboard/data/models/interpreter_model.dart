class InterpreterModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String role;
  final bool isVerified;
  final String bio;
  final String rate;       // formatted, e.g. "$2500.00/hr"
  final double rating;
  final String specialty;  // defaults to 'General'
  final bool isOnline;
  final String language;   // joined from languages list, e.g. "English, Urdu"

  const InterpreterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.role,
    required this.isVerified,
    required this.bio,
    required this.rate,
    required this.rating,
    required this.specialty,
    required this.isOnline,
    required this.language,
  });

  factory InterpreterModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const InterpreterModel(
        id: 0,
        name: 'Unknown Interpreter',
        email: '',
        phone: '',
        profileImage: '',
        role: '',
        isVerified: false,
        bio: '',
        rate: '',
        rating: 0.0,
        specialty: 'General',
        isOnline: false,
        language: '',
      );
    }

    final rawRate = _readString(
      json,
      const ['hourly_rate', 'hourlyRate', 'rate', 'pricePerHour'],
    );

    return InterpreterModel(
      id: _readInt(json, const ['id', '_id']),
      name: () {
        final n = _readString(json, const ['name', 'fullName']).trim();
        return n.isEmpty ? 'Unknown Interpreter' : n;
      }(),
      email: _readString(json, const ['email']),
      phone: _readString(json, const ['phone']),
      profileImage: _readString(
        json,
        const ['profile_image', 'profileImage', 'avatar', 'image'],
      ),
      role: _readString(json, const ['role']),
      isVerified: json['isVerified'] == true,
      bio: _readString(json, const ['bio', 'description']),
      rate: rawRate.isEmpty ? '' : _formatRate(rawRate),
      rating: _readDouble(json, const ['rating', 'avgRating', 'averageRating']),
      specialty: _readSpecialty(json),
      isOnline: json['isOnline'] == true,
      language: _readLanguage(json),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'profile_image': profileImage,
        'role': role,
        'isVerified': isVerified,
        'bio': bio,
        'hourly_rate': rate,
        'rating': rating,
        'specialty': specialty,
        'isOnline': isOnline,
        'language': language,
      };

  static String _readSpecialty(Map<String, dynamic> json) {
    final s = _readString(json, const ['specialty', 'speciality', 'category']);
    return s.isEmpty ? 'General' : s;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final dynamic value = json[key];
      if (value == null) continue;
      if (value is String) return value;
      if (value is num || value is bool) return value.toString();
    }
    return '';
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {  // ignore: unused_element
    for (final key in keys) {
      final dynamic value = json[key];
      if (value == null) continue;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value.trim());
        if (parsed != null) return parsed;
      }
    }
    return 0;
  }

  static double _readDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final dynamic value = json[key];
      if (value == null) continue;
      if (value is double) return value;
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value.trim());
        if (parsed != null) return parsed;
      }
    }
    return 0;
  }

  static String _readLanguage(Map<String, dynamic> json) {
    final dynamic value = json['languages'] ?? json['language'];

    if (value is String) {
      return value;
    }

    if (value is List) {
      final normalized = value
          .whereType<Object>()
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return normalized.join(', ');
    }

    return '';
  }

  static String _formatRate(String rawRate) {
    final trimmed = rawRate.trim();
    if (trimmed.isEmpty) return '';

    if (trimmed.contains('/')) return trimmed;

    final numericPart = trimmed.replaceAll(RegExp(r'[^0-9.]'), '');
    if (numericPart.isEmpty) return trimmed;

    return '\$$numericPart/hr';
  }
}
