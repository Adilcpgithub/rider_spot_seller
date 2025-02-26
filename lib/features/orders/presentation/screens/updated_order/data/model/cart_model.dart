import 'package:equatable/equatable.dart';

class MyCartModel extends Equatable {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String brand;
  final int productCount;
  double get priceAsDouble => price.toDouble();
  double get subtotal => priceAsDouble * productCount;

  const MyCartModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.brand,
      required this.productCount});
  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'brand': brand,
      'productCount': productCount,
    };
  }

  factory MyCartModel.fromMap(Map<String, dynamic> map) {
    return MyCartModel(
        id: map['productId'] ?? '',
        name: map['name'] ?? '',
        price: map['price'] ?? 0,
        imageUrl: map['imageUrl'] ?? '',
        brand: map['brand'] ?? '',
        productCount: map['productCount'] ?? 1);
  }
  MyCartModel copyWith({
    String? id,
    String? name,
    int? price,
    String? imageUrl,
    String? brand,
    int? productCount,
  }) {
    return MyCartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  List<Object?> get props => [id, name, price, imageUrl, brand, productCount];
}
