part of 'admin_order_bloc.dart';

sealed class AdminOrderEvent extends Equatable {
  const AdminOrderEvent();

  @override
  List<Object> get props => [];
}

class FetchAllOrders extends AdminOrderEvent {}

class UpdateOrderStatus extends AdminOrderEvent {
  final String orderId;
  final String newStatus;

  const UpdateOrderStatus({required this.orderId, required this.newStatus});

  @override
  List<Object> get props => [orderId, newStatus];
}
