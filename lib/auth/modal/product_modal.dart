import 'dart:developer';

class Cycles {
  final List<String> images;
  final String category;
  final String cycleName;
  final String brand;
  final String price;
  final String description;

  Cycles(
      {required this.category,
      required this.cycleName,
      required this.brand,
      required this.price,
      required this.description,
      required this.images});

  factory Cycles.fromMap(Map<String, dynamic> map) {
    log('jjjjjjjjjj');
    var images = <String>[]; // Default empty list in case of issues

    if (map['image_url'] is List) {
      images = (map['image_url'] as List)
          .where((e) => e is String)
          .map((e) => e as String)
          .toList();
    } else {
      log('images field is not a List');
    }

    return Cycles(
        category: map['category'],
        cycleName: map['name'],
        brand: map['brand'],
        price: map['price'],
        description: map['description'],
        images: images);
  }
}
