import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');

  //!  fetching All categories
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();

      return querySnapshot.docs
          .map((doc) =>
              CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch categories");
    }
  }

  //! Uploading image to fireStore
  Future<String> uploadImage(File imageFile) async {
    final ref = storage.ref().child('category_images/${DateTime.now()}.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  //!repository for updatate Category
  Future<void> updateCategory(
      String id, String name, File? imageFile, String? oldImageUrl) async {
    String imageUrl = oldImageUrl ?? ""; // Keep existing image if no new one

    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }

    await _firestore.collection('categories').doc(id).update({
      'name': name,
      'imageUrl': imageUrl,
    });
  }
  //! Delete Category by ID

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}
