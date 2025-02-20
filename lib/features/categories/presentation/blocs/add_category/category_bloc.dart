import 'dart:io';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');

  CategoryBloc() : super(CategoryInitial()) {
    on<AddCategoryEvent>((event, emit) async {
      try {
        String? imageUrl;
        emit(CategoryLoading());
        // Upload Image to Firebase Storage
        if (event.imageFile != null) {
          Reference ref = storage.ref().child(
              "category_images/${DateTime.now().millisecondsSinceEpoch}.jpg");
          UploadTask uploadTask = ref.putFile(event.imageFile!);
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        }
        // Reference to the "categories" collection
        CollectionReference categories = firestore.collection("categories");

        // Check if the category already exists
        QuerySnapshot querySnapshot =
            await categories.where("name", isEqualTo: event.categoryName).get();

        if (querySnapshot.docs.isNotEmpty) {
          emit(CategoryAlreadExist());
          return;
        }

        // Add Category to Firestore
        await firestore.collection("categories").add({
          "name": event.categoryName,
          "imageUrl": imageUrl ?? "",
          "createdAt": DateTime.now(),
        });

        emit(CategoryAddedSuccess());
      } catch (e) {
        log(e.toString());
        emit(CategoryAddedFailure(error: e.toString()));
      }
    });
  }
}
