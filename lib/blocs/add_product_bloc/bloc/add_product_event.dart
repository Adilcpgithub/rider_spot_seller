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

  SubmitCycleDetailsEvent({
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.description,
  });
}

class GetProduct extends AddProductEvent {}
