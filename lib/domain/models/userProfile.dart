class UserProfile {
  final String? userId;
  final String? fullName;
  final String? passport;
  final String? snils;
  final String? phone;
  final String? email;

  const UserProfile({
    this.userId,
    this.fullName,
    this.passport,
    this.snils,
    this.phone,
    this.email,
  });

  UserProfile copyWith({
    String? userId,
    String? fullName,
    String? passport,
    String? snils,
    String? phone,
    String? email,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      passport: passport ?? this.passport,
      snils: snils ?? this.snils,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      passport: json['passport'] as String?,
      snils: json['snils'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (fullName != null) 'fullName': fullName,
      if (passport != null) 'passport': passport,
      if (snils != null) 'snils': snils,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
    };
  }
}