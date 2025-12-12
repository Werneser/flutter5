import 'package:flutter5/domain/models/UserProfile.dart';

class ProfileRemoteDataSource {
  UserProfile _profile = const UserProfile();

  UserProfile getProfile() {
    return _profile;
  }

  void updateProfile(UserProfile profile) {
    _profile = profile;
  }
}
