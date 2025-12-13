import 'service.dart';

enum UserServiceStatus {
  submitted,
  inReview,
  approved,
  rejected,
  needsInfo,
}

extension UserServiceStatusX on UserServiceStatus {
  String get label {
    switch (this) {
      case UserServiceStatus.submitted:
        return 'Отправлено';
      case UserServiceStatus.inReview:
        return 'В обработке';
      case UserServiceStatus.approved:
        return 'Одобрено';
      case UserServiceStatus.rejected:
        return 'Отклонено';
      case UserServiceStatus.needsInfo:
        return 'Требуются данные';
    }
  }
}

class UserService {
  final String id;
  final Service service;
  final DateTime appliedAt;
  final UserServiceStatus status;
  final Map<String, String> formData;

  const UserService({
    required this.id,
    required this.service,
    required this.appliedAt,
    required this.status,
    this.formData = const {},
  });

  UserService copyWith({
    String? id,
    Service? service,
    DateTime? appliedAt,
    UserServiceStatus? status,
    Map<String, String>? formData,
  }) {
    return UserService(
      id: id ?? this.id,
      service: service ?? this.service,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      formData: formData ?? this.formData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': {
        'id': service.id,
        'title': service.title,
        'description': service.description,
        'category': service.category.index,
        'requiredFields': service.requiredFields,
      },
      'appliedAt': appliedAt.toIso8601String(),
      'status': status.index,
      'formData': formData,
    };
  }

  factory UserService.fromJson(Map<String, dynamic> json) {
    return UserService(
      id: json['id'],
      service: Service(
        id: json['service']['id'],
        title: json['service']['title'],
        description: json['service']['description'],
        category: ServiceCategory.values[json['service']['category']],
        requiredFields: List<String>.from(json['service']['requiredFields']),
      ),
      appliedAt: DateTime.parse(json['appliedAt']),
      status: UserServiceStatus.values[json['status']],
      formData: Map<String, String>.from(json['formData']),
    );
  }
}