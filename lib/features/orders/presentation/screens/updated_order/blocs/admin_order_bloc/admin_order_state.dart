part of 'admin_order_bloc.dart';

sealed class AdminOrderState extends Equatable {
  const AdminOrderState();

  @override
  List<Object> get props => [];
}

final class AdminOrderInitial extends AdminOrderState {}

class AdminOrderLoading extends AdminOrderState {}

class AdminOrderLoaded extends AdminOrderState {
  final List<OrderModel> orders;

  const AdminOrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class AdminOrderError extends AdminOrderState {
  final String message;

  const AdminOrderError(this.message);

  @override
  List<Object> get props => [message];
}
