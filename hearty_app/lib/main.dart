import 'package:flutter/material.dart';
import 'package:hearty/screens/authentication/LoginScreen.dart';
import 'package:hearty/logic/repository/auth_provider.dart';
import 'package:hearty/screens/navigation/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.black,
          colorScheme: ColorScheme(
            primary: Colors.red, //  primary color
            secondary: Colors.red, //  secondary color
            surface: Colors.white, // surface color
            background: Colors.white, // background color
            error: Colors.red, //  error color
            onPrimary: Colors.white, // text color on primary
            onSecondary: Colors.white, // text color on secondary
            onSurface: Colors.black, // text color on surface
            onBackground: Colors.black, // text color on background
            onError: Colors.white, // color on error
            brightness: Brightness.light, // brightness
          ),
        ),
        home: AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authRepository = AuthProvider.of(context);

    return AnimatedBuilder(
      animation: authRepository,
      builder: (context, _) {
        if (authRepository.isAuthenticated) {
          return MainScreen(); // Navigate to MainScreen
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
