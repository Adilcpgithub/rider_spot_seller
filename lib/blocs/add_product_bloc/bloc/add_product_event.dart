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
  final List<File> images;

  const SubmitCycleDetailsEvent(
      {required this.name,
      required this.brand,
      required this.price,
      required this.category,
      required this.description,
      required this.images});
  @override
  List<Object?> get props =>
      [name, brand, price, category, description, images];
}

class SubmitCycleDetailsOnUpdateEvent extends AddProductEvent {
  final String name;
  final String brand;
  final String price;
  final String category;
  final String description;
  final String documentId;
  final List<String> networkImages;
  final List<File> newImages;
  const SubmitCycleDetailsOnUpdateEvent(
      {required this.name,
      required this.brand,
      required this.price,
      required this.category,
      required this.description,
      required this.documentId,
      required this.networkImages,
      required this.newImages});
  @override
  List<Object?> get props => [
        name,
        brand,
        price,
        category,
        description,
        documentId,
        networkImages,
        newImages
      ];
}

class GetProduct extends AddProductEvent {}

class DeleteProduct extends AddProductEvent {}
