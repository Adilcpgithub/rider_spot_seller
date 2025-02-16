part of 'add_product_bloc.dart';

@immutable
sealed class AddProductState extends Equatable {
  const AddProductState();
  @override
  List<Object?> get props => [];
}

final class AddProductInitial extends AddProductState {}

// ignore: must_be_immutable
class ShowAddProductImage extends AddProductState {
  File fileImage;
  ShowAddProductImage({required this.fileImage});
  @override
  List<Object?> get props => [fileImage];
}

class AddImageLoading extends AddProductState {}

class AddProductFailure extends AddProductState {
  final String error;
  const AddProductFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class ShowAllProduct extends AddProductState {
  final List<Map<String, dynamic>>? cycles;

  @override
  String toString() {
    return 'now cycles length is ${cycles?.length}';
  }

  @override
  List<Object?> get props => [cycles];
  const ShowAllProduct(this.cycles);
}
