part of 'add_product_bloc.dart';

@immutable
sealed class AddProductEvent extends Equatable {
  const AddProductEvent();
  @override
  List<Object?> get props => [];
}

class AddProductImage extends AddProductEvent {}

class SubmitCycleDetailsEvent extends AddProductEvent {
  final String name;
  final String brand;
  final String price;
  final String category;
  final String description;

  const SubmitCycleDetailsEvent({
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.description,
  });
  @override
  List<Object?> get props => [name, brand, price, category, description];
}

class SubmitCycleDetailsOnUpdateEvent extends AddProductEvent {
  final String name;
  final String brand;
  final String price;
  final String category;
  final String description;
  final String documentId;
  String? fileimage;

  SubmitCycleDetailsOnUpdateEvent(
      {required this.name,
      required this.brand,
      required this.price,
      required this.category,
      required this.description,
      required this.documentId,
      this.fileimage});
  @override
  List<Object?> get props =>
      [name, brand, price, category, description, documentId, fileimage];
}

class GetProduct extends AddProductEvent {}

class DeleteProduct extends AddProductEvent {}
