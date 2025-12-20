import 'package:dio/dio.dart';

class PhoneIntelligenceService {
  final Dio _dio = Dio();
  final String _apiKey = '53fd18b91e2b4591b507b0c1d7d97b69';

  Future<bool> checkPhone(String phone) async {
    try {
      final response = await _dio.get(
        'https://phoneintelligence.abstractapi.com/v1/',
        queryParameters: {
          'api_key': _apiKey,
          'phone': phone,
        },
      );

      if (response.data is Map<String, dynamic>) {
        final phoneValidation = response.data['phone_validation'];
        if (phoneValidation is Map<String, dynamic>) {
          return phoneValidation['is_valid'] == true;
        }
      }
      return false;
    } on DioException catch (e) {
      throw Exception('Ошибка при проверке телефона: ${e.message}');
    }
  }
}
