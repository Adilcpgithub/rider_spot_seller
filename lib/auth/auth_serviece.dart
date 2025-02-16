import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_spot/core/shared_prefs.dart';

class AuthResponse {
  final bool success;
  final String? errorMessage;

  AuthResponse({required this.success, this.errorMessage});
}

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');
  final AdminStatus userStatus = AdminStatus();

//--------------------------------------------------------------

  Future<void> storeDataToFirebase({
    required String email,
    required String userId,
    required String phoneNumber,
    required String name,
    String? imageUrl,
  }) async {
    await _firestore.collection('seller').doc(userId).set({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': 'seller',
      if (imageUrl != null) 'profileImage': imageUrl,
    }, SetOptions(merge: true));
  }

  //! Image Picking
  Future<String?> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile?.path == null) {
      log('image picking failed');
      return null;
    }
    log(pickedFile!.path);
    File? imageFile = File(pickedFile.path);
    return await uploadImageToFireStore(imageFile);
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImageToFireStore(File imageFile) async {
    log('1');
    try {
      final ref =
          _storage.ref().child('seller/${AdminStatus.userId}/profileImage.jpg');
      final uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      log('2');
      // Get the download URL
      final imageUrl = await ref.getDownloadURL();
      log('3');

      // Save the URL to Firestore
      try {
        await _firestore.collection('seller').doc(AdminStatus.userId).set({
          'profileImage': imageUrl,
        }, SetOptions(merge: true));
        log('4');
        return imageUrl;
      } catch (e) {
        log('error coccoure when store image url in firestore :$e');
      }
    } catch (e) {
      log(e.toString());
      // print('Error uploading image: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    log('get user data called');
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('seller').doc(userId).get();

      // Check if the document exists and return the data
      if (userSnapshot.exists) {
        // log(1.toString());
        // (userSnapshot.data() as Map<String, dynamic>);

        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        log(2.toString());
        log('User not found in Firestore');
        return null;
      }
    } catch (e) {
      log(3.toString());
      log('Error retrieving user data: $e');
      return null;
    }
  }

  //----------------------------------------
  Future<bool> logInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    const String adminEmail = "admin@gmail.com";
    const String adminPassword = "riderspot401#";
    try {
      if (email == adminEmail && password == adminPassword) {
        await AdminStatus.setAdminLogin(true);
        return true;
      }
    } catch (e) {
      log('form firebase $e');
      return false;
    }

    return false;
  }

  Future<void> signOut() async {}

  Future<void> deleteCycle(String documentId) async {
    try {
      // Reference to the specific cycle document
      final cycleDocRef = FirebaseFirestore.instance.collection('cycles');

      // Delete the document
      await cycleDocRef.doc(documentId).delete();

      log('Cycle with ID $documentId deleted successfully.');
    } catch (e) {
      log('Error deleting cycle: $e');
    }
  }

  getAlldata() async {
    const userId = AdminStatus.userId;

    if (userId.isEmpty) {
      log('Error: User ID is null or empty');
      return; // Exit the function early to prevent further errors
    }
    log(userId);
    final cyclesSnapshot =
        await FirebaseFirestore.instance.collectionGroup('cycles').get();
    if (cyclesSnapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> allCycles = cyclesSnapshot.docs.map((doc) {
        return doc.data(); // Returns all data in the cycle document
      }).toList();
      return allCycles;
    }
  }
}
