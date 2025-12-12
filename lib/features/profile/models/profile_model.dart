
class Profile {
  final String fullName;
  final String passport;
  final String snils;
  final String phone;
  final String email;

  const Profile({
    this.fullName = '',
    this.passport = '',
    this.snils = '',
    this.phone = '',
    this.email = '',
  });

  Profile copyWith({
    String? fullName,
    String? passport,
    String? snils,
    String? phone,
    String? email,
  }) {
    return Profile(
      fullName: fullName ?? this.fullName,
      passport: passport ?? this.passport,
      snils: snils ?? this.snils,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  factory Profile.empty() => const Profile();
}