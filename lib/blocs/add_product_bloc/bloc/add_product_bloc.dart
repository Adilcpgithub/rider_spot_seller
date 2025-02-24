import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_spot/core/shared_prefs.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(AddProductInitial()) {
    on<AddProductImage>(_onUploadProductImage);
    on<SubmitCycleDetailsEvent>(_onSubmitCyleDetails);
    on<GetProduct>(_getSellerProduct);
    on<SubmitCycleDetailsOnUpdateEvent>(_onUpdateSubmitCyleDetails);
    on<DeleteProduct>(deletProduct);
  }
  AdminStatus userStatus = AdminStatus();
  File? finalImage;

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
        emit(const AddProductFailure("No image selected"));
      }
    } catch (e) {
      emit(AddProductFailure(e.toString()));
    }
  }

//! uplading image from gallery
  Future<File?> _uploadImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile?.path == null) {
        return null;
      }
      if (pickedFile != null) {
        finalImage = File(pickedFile.path);
        log(pickedFile.path.toString());
      } else {
        return null;
      }

      File? imageFile = File(pickedFile.path);
      return imageFile;
      // return await uploadImageToFireStore(imageFile);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> _onSubmitCyleDetails(
      SubmitCycleDetailsEvent event, Emitter<AddProductState> emit) async {
    try {
      const userId = AdminStatus.userId;
      log('checking000');
      final file = event.images;
      log('file lenght  is ${file.length}');
      log('checking111');
      List<String> imageList = [];

      if (file.isNotEmpty) {
        for (int i = 0; i < file.length; i++) {
          final uniqueImageName =
              DateTime.now().millisecondsSinceEpoch.toString();
          log('uploading image to firebase');
          log(' sssssssssssssssssssssss');
          final ref =
              _storage.ref().child('admin/$uniqueImageName/cycle_image.jpg');

          final uploadTask = ref.putFile(file[i]);
          await uploadTask.whenComplete(() {});
          final imageUrl = await ref.getDownloadURL();
          log('${imageList.length}');
          imageList.add(imageUrl);
        }
      }

      log('adding images to firebase ');
      log(event.name);
      log(event.brand);
      log(event.price.toString());
      log(event.category);
      log(event.description);
      log(userId);
      log(event.name);
      // Add new product
      await _firestore.collection('cycles').add({
        'name': event.name,
        'brand': event.brand,
        'price': event.price,
        'category': event.category,
        'description': event.description,
        'image_url': imageList,
        'seller_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Important: Fetch updated data immediately after adding
      await _getSellerProduct(GetProduct(category: event.category), emit);
    } catch (e) {
      log(e.toString());
      emit(AddProductFailure(e.toString()));
    }
  }

  Future<void> _onUpdateSubmitCyleDetails(SubmitCycleDetailsOnUpdateEvent event,
      Emitter<AddProductState> emit) async {
    log('hhhhhhhhh');
    try {
      const userId = AdminStatus.userId;

      if (userId.isEmpty) {
        log('hhhhhhhhh empty');
        emit(const AddProductFailure('User ID is missing'));
        return;
      }
      log('hhhhhhhhhkkkkkkkkk');
      // Upload image and get URL (existing code)
      final file = event.newImages;
      List<String> imageList = [];
      if (file.isNotEmpty) {
        log('checking000');
        for (int i = 0; i < file.length; i++) {
          log('checking 11');
          final uniqueImageName =
              DateTime.now().millisecondsSinceEpoch.toString();
          final ref =
              _storage.ref().child('admin/$uniqueImageName/cycle_image.jpg');
          log('checking 22');
          final uploadTask = ref.putFile(file[i]);
          log('checking 333');
          await uploadTask.whenComplete(() {});
          log('checking 444');
          final imageUrl = await ref.getDownloadURL();
          log('checking 555');
          imageList.add(imageUrl);
        }
      }
      //! here i am companing the existion network images and updatedimages from file
      List<String> allImages = [...event.networkImages, ...imageList];

      log('message from adding 1');
      await _firestore.collection('cycles').doc(event.documentId).update({
        'name': event.name,
        'brand': event.brand,
        'price': event.price,
        'category': event.category,
        'description': event.description,
        'image_url': allImages,
        'seller_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      });
      log('message from adding 2');

      await _getSellerProduct(GetProduct(category: event.category), emit);
    } catch (e) {
      log('message from adding 3');
      emit(AddProductFailure(e.toString()));
    }
  }

  Future<void> _getSellerProduct(
      GetProduct event, Emitter<AddProductState> emit) async {
    try {
      emit(AddProductLoading());
      // const userId = AdminStatus.userId;

      // Get products with ordering
      final QuerySnapshot cyclesSnapshot;
      if (event.category != null) {
        log('category is not null');
        cyclesSnapshot = await _firestore
            .collection('cycles')
            .where('category', isEqualTo: event.category!)
            .get();
      } else {
        log('category is not null');
        cyclesSnapshot = await _firestore.collection('cycles').get();
      }

      List<Map<String, dynamic>> cycles = cyclesSnapshot.docs.map((doc) {
        return {...doc.data() as Map<String, dynamic>, 'documentId': doc.id};
      }).toList();
      log('cycles length is ${cycles.length}');
      log('cycles length is $cycles');

      emit(ShowAllProduct(cycles));
    } catch (e) {
      log('Error fetching products: $e');
      emit(AddProductFailure(e.toString()));
    }
  }

  deletProduct(DeleteProduct event, Emitter<AddProductState> emit) {
    if (state is ShowAllProduct) {
      final currentState = state as ShowAllProduct;
      if (currentState.cycles!.isNotEmpty) {
        List<Map<String, dynamic>> updatedcycles =
            List.from(currentState.cycles!);
        updatedcycles.removeWhere(
          (category) => category['documentId'] == event.productId,
        );
        emit(ShowAllProduct(updatedcycles));
      }
    }
  }
}
