// utils.dart

Map<String, dynamic> formatUserData(Map<String, dynamic> userData) {
  return {
    "Name": userData['name'] ?? "N/A",
    "Age": userData['age'] ?? "N/A",
    "Gender": userData['gender'] ?? "N/A",
    "Email": userData['email'] ?? "N/A",
  };
}
