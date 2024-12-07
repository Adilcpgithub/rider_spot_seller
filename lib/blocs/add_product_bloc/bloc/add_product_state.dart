part of 'add_product_bloc.dart';

@immutable
sealed class AddProductState extends Equatable {
  const AddProductState();
  @override
  List<Object?> get props => [];
}

final class AddProductInitial extends AddProductState {}

class ShowAddProductImage extends AddProductState {
  File? fileImage;
  ShowAddProductImage({this.fileImage});
  @override
  List<Object?> get props => [fileImage];
}

class AddImageLoading extends AddProductState {}

class AddProductFailure extends AddProductState {
  final String error;
  AddProductFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class ShowAllProduct extends AddProductState {
  final List<Map<String, dynamic>>? cycles;
  const ShowAllProduct(this.cycles);
}
