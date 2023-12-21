import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearty/screens/navigation/navigation.dart';
import 'package:hearty/screens/widgets/customButton.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController errorController = TextEditingController();

  // Function to handle user registration with Firebase
  Future<void> signUpWithFirebase(BuildContext context, String email,
      String password, String name, String gender, String age) async {
    try {
      // Create a new user with email and password
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user
      final user = userCredential.user;

      // Check if user is not null before accessing 'uid'
      if (user != null) {
        // Add user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'navn': name,
          'email': email,
          'køn': gender,
          'alder': age,
        });

        // Navigate to the next screen (e.g., MainScreen) after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // Handle the case where 'user' is null (registration failed)
        print('User is null after registration');
        errorController.text = 'Registration failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      print('Error signing up with Firebase: ${e.message}');
      errorController.text = e.message!;
    } catch (e) {
      print('Unexpected error: $e');
      errorController.text = 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: const Text(
                'Opret & få adgang til dine sundhedsdata 💗',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: emailController,
              decoration: custominputDecoration.copyWith(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              decoration: custominputDecoration.copyWith(
                labelText: 'Kodeord',
                errorText: errorController.text.isNotEmpty
                    ? errorController.text
                    : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: nameController,
              decoration: custominputDecoration.copyWith(labelText: 'Navn'),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: genderController,
              decoration: custominputDecoration.copyWith(labelText: 'Dit køn'),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: ageController,
              decoration:
                  custominputDecoration.copyWith(labelText: 'Din alder'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: customButtonDecoration,
              child: const Text('Skab konto'), // Update button text
              onPressed: () {
                // Clear previous error message
                errorController.clear();

                // Call the signUpWithFirebase function with user input data
                signUpWithFirebase(
                  context,
                  emailController.text,
                  passwordController.text,
                  nameController.text,
                  genderController.text,
                  ageController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
