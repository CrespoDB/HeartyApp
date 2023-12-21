import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> uploadImageToFirebase(String userId) async {
  final storage = FirebaseStorage.instance;
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/ecg_graph.png';
  final imageFile = File(imagePath);

  if (await imageFile.exists()) {
    try {
      // Uuser-specific folder in Firebase Storage
      final storageRef =
          storage.ref().child('user_uploads/$userId/ecg_graph.png');
      await storageRef.putFile(imageFile);

      final downloadURL = await storageRef.getDownloadURL();
      print('Image uploaded to Firebase Storage. Download URL: $downloadURL');
    } catch (e) {
      // Handle any errors that occur during the upload
      print('Error uploading image to Firebase Storage: $e');
    }
  } else {
    //Case where the image file does not exist
    print('Image not found at $imagePath');
  }
}
