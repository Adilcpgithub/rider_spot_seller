part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  const CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryAddedSuccess extends CategoryState {}

class CategoryAlreadExist extends CategoryState {}

class CategoryUpdatedSuccess extends CategoryState {}

class CategoryAddedFailure extends CategoryState {
  final String error;

  const CategoryAddedFailure({required this.error});

  @override
  List<Object> get props => [error];
}
