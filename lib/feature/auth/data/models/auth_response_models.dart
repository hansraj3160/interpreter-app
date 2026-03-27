class AuthUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String preferredLanguage;
  final String profileImage;
  final String role;
  final bool isVerified;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.preferredLanguage,
    required this.profileImage,
    required this.role,
    required this.isVerified,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AuthUserModel(
        id: 0,
        name: '',
        email: '',
        phone: '',
        preferredLanguage: '',
        profileImage: '',
        role: '',
        isVerified: false,
      );
    }

    return AuthUserModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      phone: _asString(json['phone']),
      preferredLanguage: _asString(json['preferred_language']),
      profileImage: _asString(json['profile_image']),
      role: _asString(json['role']),
      isVerified: _asBool(json['isVerified']),
    );
  }
}

class LoginDataModel {
  final AuthUserModel user;
  final String token;

  const LoginDataModel({
    required this.user,
    required this.token,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LoginDataModel(
        user: const AuthUserModel(
          id: 0,
          name: '',
          email: '',
          phone: '',
          preferredLanguage: '',
          profileImage: '',
          role: '',
          isVerified: false,
        ),
        token: '',
      );
    }

    return LoginDataModel(
      user: AuthUserModel.fromJson(_asMap(json['user'])),
      token: _asString(json['token']),
    );
  }
}

class LoginResponseModel {
  final bool success;
  final String message;
  final LoginDataModel data;

  const LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(dynamic json) {
    final map = _asMap(json);
    return LoginResponseModel(
      success: _asBool(map?['success']),
      message: _asString(map?['message']),
      data: LoginDataModel.fromJson(_asMap(map?['data'])),
    );
  }
}

class SignupDataModel {
  final int userId;

  const SignupDataModel({required this.userId});

  factory SignupDataModel.fromJson(Map<String, dynamic>? json) {
    return SignupDataModel(userId: _asInt(json?['userId']));
  }
}

class SignupResponseModel {
  final bool success;
  final String message;
  final SignupDataModel data;

  const SignupResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignupResponseModel.fromJson(dynamic json) {
    final map = _asMap(json);
    return SignupResponseModel(
      success: _asBool(map?['success']),
      message: _asString(map?['message']),
      data: SignupDataModel.fromJson(_asMap(map?['data'])),
    );
  }
}

class ForgotPasswordDataModel {
  final String otp;
  final String expiresAt;
  final String email;

  const ForgotPasswordDataModel({
    required this.otp,
    required this.expiresAt,
    required this.email,
  });

  factory ForgotPasswordDataModel.fromJson(Map<String, dynamic>? json) {
    return ForgotPasswordDataModel(
      otp: _asString(json?['otp']),
      expiresAt: _asString(json?['expiresAt']),
      email: _asString(json?['email']),
    );
  }
}

class ForgotPasswordResponseModel {
  final bool success;
  final String message;
  final ForgotPasswordDataModel data;

  const ForgotPasswordResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForgotPasswordResponseModel.fromJson(dynamic json) {
    final map = _asMap(json);
    return ForgotPasswordResponseModel(
      success: _asBool(map?['success']),
      message: _asString(map?['message']),
      data: ForgotPasswordDataModel.fromJson(_asMap(map?['data'])),
    );
  }
}

class ResetPasswordResponseModel {
  final bool success;
  final String message;

  const ResetPasswordResponseModel({
    required this.success,
    required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(dynamic json) {
    final map = _asMap(json);
    return ResetPasswordResponseModel(
      success: _asBool(map?['success']),
      message: _asString(map?['message']),
    );
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
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

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  if (value is num) return value == 1;
  return false;
}
