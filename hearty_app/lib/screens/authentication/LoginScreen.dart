import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hearty/screens/widgets/customButton.dart';
import 'SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hearty/screens/navigation/navigation.dart';
import 'package:hearty/services/user_info_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final UserInfoService userInfoService = UserInfoService();

  // Function to handle login with Firebase
  Future<void> loginWithFirebase(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch and cache user data
      String userId = userCredential.user!.uid;
      await userInfoService.fetchUserData(userId);

      // If login is successful, navigate to Mainscreen. We have set this to be Navigationbar, which is routed to HomePage as default.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      print('Error logging in with Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/HeartyLogo.png'),
            const SizedBox(height: 15),
            // E-mail
            TextFormField(
              controller: emailController,
              decoration: custominputDecoration.copyWith(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10.0),
            // Password
            TextFormField(
              controller: passwordController,
              decoration: custominputDecoration.copyWith(labelText: 'Kodeord'),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: customButtonDecoration
                  .merge(ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ))
                  .merge(ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  )),
              onPressed: () {
                // Call the loginWithFirebase function with email and password input
                loginWithFirebase(
                  context,
                  emailController.text,
                  passwordController.text,
                );
              },
              child: const Text(
                'Log ind',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'Opret konto',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
            ),
            // Debug button to bypass authentication (only in debug mode)
            if (kDebugMode)
              TextButton(
                style: customButtonDecoration,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                child: const Text(
                  'Debug Bypass Auth',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
