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
    on<SubmitCycleDetailsOnUpdateEvent>(_onUpdateSubmitCyleDetails);
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
    try {
      UserStatus userStatus = UserStatus();
      final userId = await userStatus.getSellerId();

      if (userId.isEmpty) {
        emit(AddProductFailure('User ID is missing'));
        return;
      }

      // Upload image and get URL (existing code)
      final file = (state as ShowAddProductImage).fileImage;
      final uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage
          .ref()
          .child('seller/${userId}/${uniqueImageName}/cycle_image.jpg');

      final uploadTask = ref.putFile(file!);
      await uploadTask.whenComplete(() {});
      final imageUrl = await ref.getDownloadURL();

      // Add new product
      await _firestore.collection('cycles').add({
        'name': event.name,
        'brand': event.brand,
        'price': event.price,
        'category': event.category,
        'description': event.description,
        'image_url': imageUrl,
        'seller_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Important: Fetch updated data immediately after adding
      await _getSellerProduct(GetProduct(), emit);
    } catch (e) {
      emit(AddProductFailure(e.toString()));
    }
  }

  Future<void> _onUpdateSubmitCyleDetails(SubmitCycleDetailsOnUpdateEvent event,
      Emitter<AddProductState> emit) async {
    try {
      UserStatus userStatus = UserStatus();
      final userId = await userStatus.getSellerId();

      if (userId.isEmpty) {
        emit(AddProductFailure('User ID is missing'));
        return;
      }

      // Upload image and get URL (existing code)
      final file = (state as ShowAddProductImage).fileImage;
      final uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage
          .ref()
          .child('seller/${userId}/${uniqueImageName}/cycle_image.jpg');

      final uploadTask = ref.putFile(file!);
      await uploadTask.whenComplete(() {});
      final imageUrl = await ref.getDownloadURL();

      // Add new product
      // await _firestore.collection('cycles').add({
      //   'name': event.name,
      //   'brand': event.brand,
      //   'price': event.price,
      //   'category': event.category,
      //   'description': event.description,
      //   'image_url': imageUrl,
      //   'seller_id': userId,
      //   'created_at': FieldValue.serverTimestamp(),
      // });
      await _firestore.collection('cycles').doc(event.documentId).update({
        'name': event.name,
        'brand': event.brand,
        'price': event.price,
        'category': event.category,
        'description': event.description,
        'image_url': imageUrl,
        'seller_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Important: Fetch updated data immediately after adding
      await _getSellerProduct(GetProduct(), emit);
    } catch (e) {
      emit(AddProductFailure(e.toString()));
    }
  }

  Future<void> _getSellerProduct(
      GetProduct event, Emitter<AddProductState> emit) async {
    try {
      UserStatus userStatus = UserStatus();
      final userId = await userStatus.getSellerId();
      print('cheking data ');
      if (userId.isEmpty) {
        emit(ShowAllProduct([]));
        return;
      }
      print('user id is not empty user id is $userId');

      // Get products with ordering
      final cyclesSnapshot = await _firestore
          .collection('cycles')
          .where('seller_id', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> cycles = cyclesSnapshot.docs.map((doc) {
        return {...doc.data(), 'documentId': doc.id};
      }).toList();
      log('cycles length is ${cycles.length}');
      log('cycles length is ${cycles}');

      emit(ShowAllProduct(cycles));
    } catch (e) {
      log('Error fetching products: $e');
      emit(AddProductFailure(e.toString()));
    }
  }

  _deletProduct(DeleteProduct event, Emitter<AddProductState> emit) {}
}
