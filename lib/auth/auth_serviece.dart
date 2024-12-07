import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResponse {
  final bool success;
  final String? errorMessage;

  AuthResponse({required this.success, this.errorMessage});
}

class AuthService {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');
  final UserStatus userStatus = UserStatus();

//--------------------------------------------------------------
  Future<AuthResponse> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String phoneNumber,
    required String name,
  }) async {
    try {
      log('Creating user with email and password...');

      // Perform the email/password sign-up
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      userStatus.saveUsersSession(credential.user!.uid);
      log(' after sign up you user id is ${credential.user!.uid}');

      log(credential.toString());

      // Skip saving user data to Firestore and return a successful response
      log('User created successfully.');
      String userId = credential.user!.uid;
      storeDataToFirebase(
          email: email, userId: userId, phoneNumber: phoneNumber, name: name);
      // Save additional data to Firestore

      return AuthResponse(success: true); // Successful completion
    } on TimeoutException catch (_) {
      log('Operation timed out.');
      return AuthResponse(success: false, errorMessage: 'Operation timed out');
    } on FirebaseAuthException catch (e) {
      String errorMessage = switch (e.code) {
        'email-already-in-use' => 'Email already registered',
        'weak-password' => 'Password is too weak',
        'invalid-email' => 'Invalid email format',
        _ => 'Registration failed: ${e.message}'
      };
      return AuthResponse(success: false, errorMessage: errorMessage);
    } catch (e) {
      log('An error occurred during sign-up: $e');
      return AuthResponse(
          success: false, errorMessage: 'An unexpected error occurred');
    }
  }

  Future<void> storeDataToFirebase({
    required String email,
    required String userId,
    required String phoneNumber,
    required String name,
    String? imageUrl,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
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
      final ref = _storage
          .ref()
          .child('users/${UserStatus.userIdFinal}/profileImage.jpg');
      final uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      log('2');
      // Get the download URL
      final imageUrl = await ref.getDownloadURL();
      log('3');

      // Save the URL to Firestore
      try {
        await _firestore.collection('users').doc(UserStatus.userIdFinal).set({
          'profileImage': imageUrl,
        }, SetOptions(merge: true));
        log('4');
        return imageUrl;
      } catch (e) {
        log('error coccoure when store image url in firestore :$e');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    log('get user data called');
    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

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
  Future<AuthResponse> logInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Authentication using email and password
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log("Successfully signed in with email and password");
      log('saving user data');
      log(' after login  you user id is ${credential.user!.uid}');
      userStatus.saveUsersSession(credential.user!.uid);

      return AuthResponse(success: true);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      // Handle specific FirebaseAuth errors
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
        case 'invalid-credential':
          errorMessage = 'something went worng ';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      log('FirebaseAuthException occurred: $errorMessage');
      return AuthResponse(success: false, errorMessage: errorMessage);
    } catch (e) {
      // Handle any other unexpected errors
      log("Unexpected error during sign in: $e");
      return AuthResponse(
          success: false, errorMessage: 'An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.setBool('is_logged_in', false);
    try {
      await _auth.signOut();
    } catch (e) {
      log('sign out success');
    }
  }

  Future<void> deleteUserAccount(String email, String password) async {
    try {
      log('sssssssss');
      if (_auth.currentUser != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await _auth.currentUser!.reauthenticateWithCredential(credential);

        await _auth.currentUser!.delete();

        print('User account deleted successfully');
      } else {
        log('currnt user is null');
      }

      await _firestore
          .collection('users')
          .doc(await userStatus.getUserId())
          .delete();
    } catch (e) {
      print("Failed to delete user account: $e");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.setBool('is_logged_in', false);
  }

  // Future<void> updateName(String name) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(await userStatus.getUserId())
  //       .update({'name': name});
  // }

  // Future<void> updateEmail(String emai) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(await userStatus.getUserId())
  //       .update({'email': emai});
  // }

  // Future<void> updatephoneNumber(String phoneNumber) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(await userStatus.getUserId())
  //       .update({'phoneNumber': phoneNumber});
  // }
  Future<void> deleteCycle(String documentId) async {
    UserStatus userStatus = UserStatus();
    final userId = await userStatus.getUserId();
    try {
      // Reference to the specific cycle document
      final cycleDocRef = FirebaseFirestore.instance
          .collection('cycles')
          .doc(userId)
          .collection('cycles')
          .doc(documentId);

      // Delete the document
      await cycleDocRef.delete();

      log('Cycle with ID $documentId deleted successfully.');
    } catch (e) {
      log('Error deleting cycle: $e');
    }
  }

  getAlldata() async {
    UserStatus userStatus = UserStatus();
    final userId = await userStatus.getUserId();
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

class UserStatus {
  static String userIdFinal = '';
  Future<void> saveUsersSession(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    log('user data is daving $userId');
    await prefs.setBool('is_logged_in', true);
    await getUserId();
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userIdFinal = prefs.getString('user_id') ?? '';
    return prefs.getString('user_id') ?? '';
  }
}
