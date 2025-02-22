part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event for adding a category
class AddCategoryEvent extends CategoryEvent {
  final String categoryName;
  final File? imageFile;

  AddCategoryEvent({required this.categoryName, required this.imageFile});

  @override
  List<Object?> get props => [categoryName, imageFile];
}

// ignore: must_be_immutable
class UpdateCategoryEvent extends CategoryEvent {
  String categoryId;
  String categoryName;
  File? imageFile;
  String? imageUrl;
  UpdateCategoryEvent(
      {required this.categoryId,
      required this.categoryName,
      this.imageFile,
      this.imageUrl});

  @override
  List<Object?> get props => [categoryId, categoryName, imageFile, imageUrl];
}

class DeleteCategory extends CategoryEvent {
  final String categoryId;
  DeleteCategory(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class LoadCategories extends CategoryEvent {}
