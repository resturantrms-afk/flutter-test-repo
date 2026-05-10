import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(const OrderHistoryState()) {
    on<AddOrder>(_onAddOrder);
  }

  void _onAddOrder(AddOrder event, Emitter<OrderHistoryState> emit) {
    // Prepend the new order to the list so newest is first
    emit(OrderHistoryState(orders: [event.order, ...state.orders]));
  }
}
