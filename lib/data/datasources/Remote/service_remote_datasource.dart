import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/domain/models/service.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:get_it/get_it.dart';

class ServiceRemoteDataSource {
  final List<Service> _services = [
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

  List<Service> getServices({ServiceCategory? category, String? query}) {
    final q = query?.trim().toLowerCase() ?? '';
    return _services.where((s) {
      final catOk = category == null || s.category == category;
      final queryOk = q.isEmpty ||
          s.title.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q);
      return catOk && queryOk;
    }).toList();
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
  }
}
