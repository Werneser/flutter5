class UserProfile {
  final String fullName;
  final String passport;
  final String snils;
  final String phone;
  final String email;

  const UserProfile({
    this.fullName = '',
    this.passport = '',
    this.snils = '',
    this.phone = '',
    this.email = '',
  });

  UserProfile copyWith({
    String? fullName,
    String? passport,
    String? snils,
    String? phone,
    String? email,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      passport: passport ?? this.passport,
      snils: snils ?? this.snils,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}