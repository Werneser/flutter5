import 'package:flutter/cupertino.dart';
import 'package:flutter5/app.dart';


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