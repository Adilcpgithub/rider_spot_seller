import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/data/model/order_model.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/data/repository/order_repository.dart';

part 'admin_order_event.dart';
part 'admin_order_state.dart';

class AdminOrderBloc extends Bloc<AdminOrderEvent, AdminOrderState> {
  final OrderRepository orderRepository;
  AdminOrderBloc({required this.orderRepository}) : super(AdminOrderInitial()) {
    on<FetchAllOrders>((event, emit) async {
      emit(AdminOrderLoading());
      try {
        final orders = await orderRepository.getAllOrders();
        emit(AdminOrderLoaded(orders));
      } catch (e) {
        emit(AdminOrderError(e.toString()));
      }
    });
    on<UpdateOrderStatus>((event, emit) async {
      try {
        await orderRepository.updateOrderStatus(event.orderId, event.newStatus);
        // Refresh order list after updating
        final updatedOrders = await orderRepository.getAllOrders();
        emit(AdminOrderLoaded(updatedOrders));
      } catch (e) {
        emit(AdminOrderError(e.toString()));
      }
    });
  }
}
