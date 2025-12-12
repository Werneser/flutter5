import 'package:flutter5/domain/models/user_service.dart';

class UserServiceRemoteDataSource {
  final List<UserService> _userServices = [];

  List<UserService> getUserServicesByStatus(UserServiceStatus? status) {
    if (status == null) return _userServices;
    return _userServices.where((e) => e.status == status).toList();
  }

  void updateUserServiceStatus({required String userServiceId, required UserServiceStatus status}) {
    final index = _userServices.indexWhere((e) => e.id == userServiceId);
    if (index != -1) {
      _userServices[index] = _userServices[index].copyWith(status: status);
    }
  }

  void addUserService(UserService userService) {
    _userServices.add(userService);
  }
}
