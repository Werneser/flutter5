enum ServiceCategory {
  transport,
  healthcare,
  education,
  housing,
  taxes,
  documents,
  family,
  property,
  business,
  other,
}

extension ServiceCategoryX on ServiceCategory {
  String get label {
    switch (this) {
      case ServiceCategory.transport:
        return 'Транспорт';
      case ServiceCategory.healthcare:
        return 'Здравоохранение';
      case ServiceCategory.education:
        return 'Образование';
      case ServiceCategory.housing:
        return 'ЖКХ';
      case ServiceCategory.taxes:
        return 'Налоги';
      case ServiceCategory.documents:
        return 'Документы';
      case ServiceCategory.family:
        return 'Семья';
      case ServiceCategory.property:
        return 'Имущество';
      case ServiceCategory.business:
        return 'Бизнес';
      case ServiceCategory.other:
        return 'Другое';
    }
  }
}

class Service {
  final String id;
  final String title;
  final String description;
  final ServiceCategory category;
  final List<String> requiredFields;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.requiredFields = const [],
  });
}

