class InterpreterModel {
  final String id;
  final String name;
  final String language;
  final String specialty;
  final double rating;
  final int reviews;
  final String rate;
  final String profileImage;

  const InterpreterModel({
    required this.id,
    required this.name,
    required this.language,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.rate,
    required this.profileImage,
  });

  factory InterpreterModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const InterpreterModel(
        id: '',
        name: 'Unknown Interpreter',
        language: '',
        specialty: '',
        rating: 0,
        reviews: 0,
        rate: '',
        profileImage: '',
      );
    }

    final rateValue = _readString(
      json,
      const ['rate', 'hourlyRate', 'pricePerHour'],
    );

    return InterpreterModel(
      id: _readString(json, const ['id', '_id', 'interpreterId']),
      name: _readString(json, const ['name', 'fullName', 'interpreterName'])
          .trim()
          .isEmpty
          ? 'Unknown Interpreter'
          : _readString(json, const ['name', 'fullName', 'interpreterName'])
              .trim(),
      language: _readLanguage(json),
      specialty:
          _readString(json, const ['specialty', 'speciality', 'category']),
      rating: _readDouble(json, const ['rating', 'avgRating', 'averageRating']),
      reviews: _readInt(json, const ['reviews', 'reviewCount', 'totalReviews']),
      rate: rateValue.isEmpty ? '' : _formatRate(rateValue),
      profileImage: _readString(
        json,
        const ['profileImage', 'profile_image', 'avatar', 'image', 'photo'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'language': language,
      'specialty': specialty,
      'rating': rating,
      'reviews': reviews,
      'rate': rate,
      'profileImage': profileImage,
    };
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

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
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
    final dynamic value = json['language'] ?? json['languages'];

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
