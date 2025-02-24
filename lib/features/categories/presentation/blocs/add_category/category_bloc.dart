import 'dart:io';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ride_spot/features/categories/data/models/category_model.dart';
import 'package:ride_spot/features/categories/data/repositories/category_repository.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');
  CategoryRepository categoryRepository = CategoryRepository();

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      const List<Map<String, dynamic>> fixedCategories = [
        {
          'name': 'Mountain Bike',
          'imageUrl': 'asset/category cycles/mountain.jpg'
        },
        {
          'name': 'Road Bike',
          'imageUrl': 'asset/category cycles/Road Bike.jpeg'
        },
        {
          'name': 'Hybrid',
          'imageUrl': 'asset/category cycles/Hybrid bike.jpeg'
        },
        {
          'name': 'Electric Bikes',
          'imageUrl': 'asset/category cycles/Electric Bikes.jpg'
        },
        {
          'name': "Kids' Bikes",
          'imageUrl': "asset/category cycles/kids bike.webp"
        },
        {
          'name': 'Folding Bikes',
          'imageUrl': 'asset/category cycles/folding bike.webp'
        },
      ];
      List<CategoryModel> allcategories = [
        ...fixedCategories.map(
          (cate) {
            return CategoryModel(
                id: '',
                name: cate['name'],
                imageUrl: cate['imageUrl'],
                isEditable: false);
          },
        )
      ];
      emit(CategoryLoading());
      try {
        final categories = await categoryRepository.fetchCategories();
        emit(CategoryLoaded([...allcategories, ...categories]));
      } catch (e) {
        emit(const CategoryAddedFailure(error: "Failed to load categories"));
      }
    });
    on<AddCategoryEvent>((event, emit) async {
      try {
        String? imageUrl;
        emit(CategoryLoading());
        // Upload Image to Firebase Storage
        if (event.imageFile != null) {
          CategoryRepository categoryRepository = CategoryRepository();
          imageUrl = await categoryRepository.uploadImage(event.imageFile!);
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

    on<UpdateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        await categoryRepository.updateCategory(
          event.categoryId,
          event.categoryName,
          event.imageFile,
          event.imageUrl, // Use old image if no new one is picked
        );
        emit(CategoryUpdatedSuccess());
      } catch (e) {
        emit(CategoryAddedFailure(error: e.toString()));
      }
    });
    on<DeleteCategory>((event, emit) async {
      if (state is CategoryLoaded) {
        final currentState = state as CategoryLoaded;
        List<CategoryModel> updatedcategories =
            List.from(currentState.categories);
        updatedcategories.removeWhere(
          (category) => category.id == event.categoryId,
        );
        emit(CategoryLoaded(updatedcategories));
        await categoryRepository.deleteCategory(event.categoryId);
        // Delete cycles that belong to this category
        final cycleDocs = await FirebaseFirestore.instance
            .collection('cycles')
            .where('category', isEqualTo: event.categoryName)
            .get();
        for (var doc in cycleDocs.docs) {
          await FirebaseFirestore.instance
              .collection('cycles')
              .doc(doc.id)
              .delete();
        }
      }
    });
  }
}
