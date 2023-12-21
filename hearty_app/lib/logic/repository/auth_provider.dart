import 'package:flutter/material.dart';
import 'auth_repository.dart';

class AuthProvider extends InheritedWidget {
  final AuthRepository authRepository;

  AuthProvider({Key? key, required Widget child})
      : authRepository = AuthRepository(),
        super(key: key, child: child);

  static AuthRepository of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthProvider>()!
        .authRepository;
  }

  @override
  bool updateShouldNotify(AuthProvider oldWidget) {
    return oldWidget.authRepository != authRepository;
  }
}
