import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:hearty/services/upload_firebase.dart';
import 'package:hearty/services/user_info_service.dart';
// Add Firebase Auth import if you are using it to get the current user's ID
// import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String? imagePath;
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchAndSetUserId();
  }

  void _fetchAndSetUserId() async {
    // Replace this with the actual logic to get the current user's ID
    // For example, if you are using Firebase Auth, it would be:
    // String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    var userData = await UserInfoService().fetchUserData(currentUserId);
    if (userData != null && userData['uid'] != null) {
      setState(() {
        userId = userData['uid'];
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadCachedImagePath();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCachedImagePath();
  }

  Future<void> _loadCachedImagePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/ecg_graph.png';
    final imageFile = File(path);

    if (await imageFile.exists()) {
      setState(() {
        imagePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (userId != null && userId!.isNotEmpty) {
                  uploadImageToFirebase(userId!);
                } else {
                  print('User ID not found');
                }
              },
              child: Text('Upload Image to Firebase'),
            ),
            imagePath != null
                ? Image.file(File(imagePath!),
                    key: ValueKey(imagePath)) // Force refresh with ValueKey
                : Text("No cached ECG graph available."),
          ],
        ),
      ),
    );
  }
}
