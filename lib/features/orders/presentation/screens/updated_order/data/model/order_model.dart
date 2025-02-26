import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/data/model/cart_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final Map<String, dynamic> address;
  final List<MyCartModel> items;
  final double totalPrice;
  final String status; // 'In Progress', 'Delivered', 'Canceled'
  final Timestamp createdAt; // Firestore Timestamp

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.address,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'address': address,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt, // Store Firestore Timestamp
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      address: map['address'] ?? {},
      items: List<MyCartModel>.from(
          (map['items'] ?? []).map((item) => MyCartModel.fromMap(item))),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'In Progress',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
