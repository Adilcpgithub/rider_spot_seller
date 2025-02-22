class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final bool isEditable;
  CategoryModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      this.isEditable = true});

  factory CategoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CategoryModel(
        id: documentId,
        name: map['name'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        isEditable: true);
  }
}
