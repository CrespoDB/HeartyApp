// user_info_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoService {
  static final UserInfoService _instance = UserInfoService._internal();

  factory UserInfoService() {
    return _instance;
  }

  UserInfoService._internal();

  Map<String, dynamic>? _cachedUserData;

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    print("Fetching user data for ID: $userId"); // Debugging statement

    if (_cachedUserData != null) {
      print("Returning cached user data."); // Debugging statement
      return _cachedUserData;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        _cachedUserData = userDoc.data() as Map<String, dynamic>?;
        _cachedUserData?['uid'] = userId; // Add the UID to the cached data
        print(
            "Fetched and cached user data: $_cachedUserData"); // Debugging statement
        return _cachedUserData;
      } else {
        print("User not found"); // Debugging statement
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e"); // Debugging statement
      return null;
    }
  }

  Map<String, dynamic>? getCachedUserData() {
    return _cachedUserData;
  }

  void clearCache() {
    _cachedUserData = null;
  }
}
