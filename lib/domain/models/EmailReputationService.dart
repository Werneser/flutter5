import 'package:dio/dio.dart';

class EmailReputationService {
  final Dio _dio = Dio();
  final String _apiKey = 'de5416e078f241c78b4b840fa76b8ba8';

  Future<bool> checkEmailReputation(String email) async {
    try {
      final response = await _dio.get(
        'https://emailreputation.abstractapi.com/v1/',
        queryParameters: {
          'api_key': _apiKey,
          'email': email,
        },
      );

      if (response.data is Map<String, dynamic>) {
        final emailDeliverability = response.data['email_deliverability'];
        if (emailDeliverability is Map<String, dynamic>) {
          bool isValidEmail = emailDeliverability['status_detail'] == 'valid_email' &&
              emailDeliverability['is_format_valid'] == true;
          return isValidEmail;
        }
      }
      return false;
    } on DioException catch (e) {
      throw Exception('Ошибка при проверке email: ${e.message}');
    }
  }
}
