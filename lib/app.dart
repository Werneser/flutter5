import 'package:flutter/foundation.dart';
import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/appointment_remote_datasource.dart';
import 'package:flutter5/domain/models/userProfile.dart';
import 'package:get_it/get_it.dart';
import 'domain/models/service.dart';
import 'domain/models/appointment.dart';

class AppState extends ChangeNotifier {
  int currentTabIndex;
  List<Appointment> myServices;
  UserProfile profile;

  AppState({
    required this.currentTabIndex,
    required this.myServices,
    required this.profile,
  });

  factory AppState.initial() {
    return AppState(
      currentTabIndex: 0,
      myServices: <Appointment>[],
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
    final appointmentRemoteDataSource = GetIt.I<AppointmentRemoteDataSource>();
    final authRemoteDataSource = GetIt.I<AuthRemoteDataSource>();

    final currentUserLogin = await authRemoteDataSource.getCurrentUserLogin();
    if (currentUserLogin == null) {
      throw Exception('Пользователь не авторизован');
    }

    final id = 'app_${DateTime.now().microsecondsSinceEpoch}';
    final entry = Appointment(
      id: id,
      service: service,
      appliedAt: DateTime.now(),
      status: AppointmentStatus.submitted,
      formData: Map<String, String>.from(formData),
    );

    await appointmentRemoteDataSource.addAppointment(entry);
    myServices.add(entry);
    notifyListeners();
  }



  void updateUserServiceStatus({
    required String userServiceId,
    required AppointmentStatus status,
  }) {
    final index = myServices.indexWhere((e) => e.id == userServiceId);
    if (index == -1) return;
    myServices = [
      for (var i = 0; i < myServices.length; i++)
        if (i == index) myServices[i].copyWith(status: status) else myServices[i]
    ];
    notifyListeners();
  }

  List<Appointment> userServicesByStatus(AppointmentStatus? status) {
    if (status == null) return myServices;
    return myServices.where((e) => e.status == status).toList();
  }
}
