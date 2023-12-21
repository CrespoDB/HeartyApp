import 'package:flutter/material.dart';
import 'package:hearty/screens/home/home.dart';
import 'package:hearty/screens/home/connect.dart';
import 'package:hearty/screens/home/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hearty/services/user_info_service.dart'; // Import UserInfoService

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final UserInfoService userInfoService = UserInfoService();

  @override
  Widget build(BuildContext context) {
    // Moved _widgetOptions inside the build method
    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(), // Your HomeScreen widget
      ConnectScreen(), // Your ConnectScreen widget
      ProfileScreen(
          userInfoService:
              userInfoService), // Pass UserInfoService to ProfileScreen
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GNav(
          tabs: [
            GButton(icon: Icons.home, text: 'Hjem'),
            GButton(icon: Icons.wifi, text: 'Forbind'),
            GButton(icon: Icons.person, text: 'Profil'),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: Colors.black,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[300]!,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
