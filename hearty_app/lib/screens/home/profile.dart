// profile_screen.dart

import 'package:flutter/material.dart';
import 'package:hearty/services/user_info_service.dart';

class ProfileScreen extends StatelessWidget {
  final UserInfoService userInfoService;

  ProfileScreen({Key? key, required this.userInfoService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? userData = userInfoService.getCachedUserData();
    print("User data in ProfileScreen: $userData"); // Debugging statement

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: userData == null
            ? const Text('No user data available',
                style: TextStyle(fontSize: 24))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Navn: ${userData['navn'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'E-mail: ${userData['email'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Alder: ${userData['alder'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Køn: ${userData['køn'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 20)),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
