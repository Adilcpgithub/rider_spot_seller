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
