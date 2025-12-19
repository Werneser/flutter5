import 'package:flutter/foundation.dart';
import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/user_service_remote_datasource.dart';
import 'package:flutter5/domain/models/userProfile.dart';
import 'package:get_it/get_it.dart';
import 'domain/models/service.dart';
import 'domain/models/user_service.dart';

class AppState extends ChangeNotifier {
  int currentTabIndex;
  List<UserService> myServices;
  UserProfile profile;

  AppState({
    required this.currentTabIndex,
    required this.myServices,
    required this.profile,
  });

  factory AppState.initial() {
    return AppState(
      currentTabIndex: 0,
      myServices: <UserService>[],
      profile: const UserProfile(),
    );
  }

  void setTab(int index) {
    if (index == currentTabIndex) return;
    currentTabIndex = index;
    notifyListeners();
  }

  void updateProfile(UserProfile newProfile) {
    profile = newProfile;
    notifyListeners();
  }

  Future<void> submitApplication({
    required Service service,
    required Map<String, String> formData,
  }) async {
    final userServiceRemoteDataSource = GetIt.I<UserServiceRemoteDataSource>();
    final authRemoteDataSource = GetIt.I<AuthRemoteDataSource>();

    final currentUserLogin = await authRemoteDataSource.getCurrentUserLogin();
    if (currentUserLogin == null) {
      throw Exception('Пользователь не авторизован');
    }

    final id = 'app_${DateTime.now().microsecondsSinceEpoch}';
    final entry = UserService(
      id: id,
      service: service,
      appliedAt: DateTime.now(),
      status: UserServiceStatus.submitted,
      formData: Map<String, String>.from(formData),
    );

    await userServiceRemoteDataSource.addUserService(entry);
  }


  void updateUserServiceStatus({
    required String userServiceId,
    required UserServiceStatus status,
  }) {
    final index = myServices.indexWhere((e) => e.id == userServiceId);
    if (index == -1) return;
    myServices = [
      for (var i = 0; i < myServices.length; i++)
        if (i == index) myServices[i].copyWith(status: status) else myServices[i]
    ];
    notifyListeners();
  }

  List<UserService> userServicesByStatus(UserServiceStatus? status) {
    if (status == null) return myServices;
    return myServices.where((e) => e.status == status).toList();
  }
}
