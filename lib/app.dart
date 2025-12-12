import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'features/services/models/service.dart';
import 'features/user_services/models/user_service.dart';


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

class AppState extends ChangeNotifier {
  int currentTabIndex;
  List<Service> catalog;
  List<UserService> myServices;
  UserProfile profile;

  AppState({
    required this.currentTabIndex,
    required this.catalog,
    required this.myServices,
    required this.profile,
  });

  factory AppState.initial() {
    final demoCatalog = <Service>[
      Service(
        id: 'svc_tr_1',
        title: 'Оформление водительского удостоверения',
        description: 'Подача заявления на получение или замену ВУ.',
        category: ServiceCategory.transport,
        requiredFields: ['Категория ВУ'],
      ),
      Service(
        id: 'svc_hc_1',
        title: 'Запись к врачу',
        description: 'Электронная запись на прием к врачу по полису ОМС.',
        category: ServiceCategory.healthcare,
        requiredFields: ['Поликлиника', 'Специализация'],
      ),
      Service(
        id: 'svc_ed_1',
        title: 'Запись в детский сад',
        description: 'Подача заявления в очередь в ДОО.',
        category: ServiceCategory.education,
        requiredFields: ['Желаемая дата зачисления'],
      ),
      Service(
        id: 'svc_tx_1',
        title: 'Справка об отсутствии задолженностей',
        description: 'Получение актуальной налоговой справки.',
        category: ServiceCategory.taxes,
        requiredFields: [],
      ),
      Service(
        id: 'svc_dc_1',
        title: 'Замена паспорта РФ',
        description: 'Замена паспорта при достижении возраста, утрате, смене ФИО.',
        category: ServiceCategory.documents,
        requiredFields: ['Причина замены'],
      ),
    ];

    return AppState(
      currentTabIndex: 0,
      catalog: demoCatalog,
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

  void submitApplication({
    required Service service,
    required Map<String, String> formData,
  }) {
    final id = 'app_${DateTime.now().microsecondsSinceEpoch}';
    final entry = UserService(
      id: id,
      service: service,
      appliedAt: DateTime.now(),
      status: UserServiceStatus.submitted,
      formData: Map<String, String>.from(formData),
    );
    myServices = [...myServices, entry];
    notifyListeners();
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

  List<Service> servicesByCategory(
      ServiceCategory? category, {
        String query = '',
      }) {
    final q = query.trim().toLowerCase();
    return catalog.where((s) {
      final catOk = category == null || s.category == category;
      final queryOk = q.isEmpty ||
          s.title.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q);
      return catOk && queryOk;
    }).toList();
  }

  List<UserService> userServicesByStatus(UserServiceStatus? status) {
    if (status == null) return myServices;
    return myServices.where((e) => e.status == status).toList();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  AppStateScope({
    super.key,
    required AppState appState,
    required Widget child,
  }) : super(notifier: appState, child: child);

  static AppState of(BuildContext context) {
    final scope =
    context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}