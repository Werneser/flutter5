import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/models/userProfile.dart';

class ProfileRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ProfileRemoteDataSource(this._dio, this._storage);

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<UserProfile?> getProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('ProfileRemoteDataSource: Token is null');
        return null;
      }

      print('ProfileRemoteDataSource: Getting profile with token: $token');

      final response = await _dio.get(
        '/profile',
        options: Options(
          headers: {'Authorization': token},
        ),
      );

      print('ProfileRemoteDataSource: Response status: ${response.statusCode}');
      print('ProfileRemoteDataSource: Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final profileData = response.data['profile'];
        if (profileData != null) {
          print('ProfileRemoteDataSource: Profile data: $profileData');
          return UserProfile.fromJson(profileData as Map<String, dynamic>);
        }
      }
      print('ProfileRemoteDataSource: No profile data found');
      return null;
    } catch (e) {
      print('ProfileRemoteDataSource: Error loading profile: $e');
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<bool> updateProfile(UserProfile profile) async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('ProfileRemoteDataSource: Token is null for update');
        return false;
      }

      final updateData = profile.toJson();
      print('ProfileRemoteDataSource: Updating profile with data: $updateData');

      final response = await _dio.put(
        '/profile',
        data: updateData,
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      print('ProfileRemoteDataSource: Update response status: ${response.statusCode}');
      print('ProfileRemoteDataSource: Update response data: ${response.data}');

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      print('ProfileRemoteDataSource: Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
}