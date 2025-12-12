class SupportRemoteDataSource  {
  final List<Map<String, String>> _faq = [
    {
      'question': 'Как восстановить пароль?',
      'answer': 'Чтобы восстановить пароль, перейдите на экран авторизации и нажмите "Забыли пароль?". Следуйте инструкциям на экране.'
    },
    {
      'question': 'Как изменить данные профиля?',
      'answer': 'Вы можете изменить данные профиля, перейдя в раздел "Профиль" и нажав на кнопку "Редактировать".'
    },
    {
      'question': 'Как подать заявку на услугу?',
      'answer': 'Перейдите в раздел "Каталог", выберите нужную услугу и нажмите "Подать заявку".'
    },
    {
      'question': 'Как отследить статус заявки?',
      'answer': 'Все ваши заявки отображаются в разделе "Мои услуги". Выберите нужную заявку, чтобы увидеть её статус.'
    },
  ];

  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> getFAQ() {
    return _faq;
  }

  void sendMessage(String message) {
    _messages.add({'text': message, 'isMe': 'true'});
    _messages.add({'text': 'Спасибо за ваше сообщение! Мы ответим в ближайшее время.', 'isMe': 'false'});
  }

  List<Map<String, String>> getMessages() {
    return _messages;
  }
}

