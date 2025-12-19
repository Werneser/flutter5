import 'service.dart';

enum AppointmentStatus {
  submitted,
  inReview,
  approved,
  rejected,
  needsInfo,
}

extension AppointmentStatusX on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.submitted:
        return 'Отправлено';
      case AppointmentStatus.inReview:
        return 'В обработке';
      case AppointmentStatus.approved:
        return 'Одобрено';
      case AppointmentStatus.rejected:
        return 'Отклонено';
      case AppointmentStatus.needsInfo:
        return 'Требуются данные';
    }
  }
}

class Appointment {
  final String id;
  final Service service;
  final DateTime appliedAt;
  final AppointmentStatus status;
  final Map<String, String> formData;

  const Appointment({
    required this.id,
    required this.service,
    required this.appliedAt,
    required this.status,
    this.formData = const {},
  });

  Appointment copyWith({
    String? id,
    Service? service,
    DateTime? appliedAt,
    AppointmentStatus? status,
    Map<String, String>? formData,
  }) {
    return Appointment(
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

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      service: Service(
        id: json['service']['id'],
        title: json['service']['title'],
        description: json['service']['description'],
        category: ServiceCategory.values[json['service']['category']],
        requiredFields: List<String>.from(json['service']['requiredFields']),
      ),
      appliedAt: DateTime.parse(json['appliedAt']),
      status: AppointmentStatus.values[json['status']],
      formData: Map<String, String>.from(json['formData']),
    );
  }
}