import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:ride_spot/auth/auth_serviece.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(AddProductInitial()) {
    on<AddProductImage>(_onUploadProductImage);
    on<SubmitCycleDetailsEvent>(_onSubmitCyleDetails);
    on<GetProduct>(_getSellerProduct);
  }
  UserStatus userStatus = UserStatus();
  File? finalImage;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');
//! Uploading Product Image
  Future<void> _onUploadProductImage(
      AddProductImage event, Emitter<AddProductState> emit) async {
    try {
      final pickedImage = await _uploadImage();
      if (pickedImage != null) {
        emit(ShowAddProductImage(fileImage: pickedImage));
      } else {
        emit(AddProductFailure("No image selected"));
      }
    } catch (e) {
      emit(AddProductFailure(e.toString()));
    }
  }

//! uplading image from gallery
  Future<File?> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile?.path == null) {
      return null;
    }
    if (pickedFile != null) {
      finalImage = File(pickedFile.path);
      print(pickedFile.path.toString());
    } else {
      return null;
    }

    File? imageFile = File(pickedFile.path);
    return imageFile;
    // return await uploadImageToFireStore(imageFile);
  }

  Future<void> _onSubmitCyleDetails(
      SubmitCycleDetailsEvent event, Emitter<AddProductState> emit) async {
    // emit(AddProductLoading());
    //  'seller/${sellerId}/cycle_image.jpg'

    UserStatus userStatus = UserStatus();
    final userId = await userStatus.getUserId();
    if (userId.isEmpty) {
      log('Error: User ID is null or empty');
      return; // Exit the function early to prevent further errors
    } else {
      log(userId);
    }
    try {
      if (finalImage == null) {
        emit(AddProductFailure('no image selected'));
      } else {
        final file = (state as ShowAddProductImage).fileImage;

        final ref = _storage.ref().child('seller/${userId}/cycle_image.jpg');
        final uploadTask = ref.putFile(file!);
        await uploadTask.whenComplete(() {});

        // Get the download URL
        final imageUrl = await ref.getDownloadURL();
        final docRef = _firestore.collection('cycles').doc(userId);

        await docRef.collection('cycles').add({
          'name': event.name,
          'brand': event.brand,
          'price': event.price,
          'category': event.category,
          'description': event.description,
          'image_url': imageUrl,
          'seller_id': UserStatus.userIdFinal,
          'created_at': FieldValue.serverTimestamp(),
        });

        emit(AddProductSuccess());
      }
    } catch (e) {
      log('errr $e');
      emit(AddProductFailure(e.toString()));
    }
  }

  _getSellerProduct(GetProduct event, Emitter<AddProductState> emit) async {
    UserStatus userStatus = UserStatus();
    final userId = await userStatus.getUserId();
    if (userId.isEmpty) {
      log('Error: User ID is null or empty');
      return; // Exit the function early to prevent further errors
    }
    log(userId);
    final cyclesSnapshot = await _firestore
        .collection('cycles')
        .doc(userId)
        .collection('cycles')
        .where('seller_id', isEqualTo: userId)
        .get();

    // Check if cycles exist
    if (cyclesSnapshot.docs.isEmpty) {
      log('No cycles found for seller: $userId');
      return;
    }

    // Map results to a list
    List<Map<String, dynamic>> cycles = cyclesSnapshot.docs.map(
      (doc) {
        return {...doc.data(), 'documentId': doc.id};
      },
    ).toList();

    log('Fetched cycles: $cycles');
    // log('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmessage ${cycles[1]['documentId']}');

    emit(ShowAllProduct(cycles));
  }
}
