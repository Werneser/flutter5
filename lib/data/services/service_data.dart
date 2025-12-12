import '../../domain/models/service.dart';

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