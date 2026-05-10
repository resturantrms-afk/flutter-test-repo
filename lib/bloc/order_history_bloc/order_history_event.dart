import 'package:equatable/equatable.dart';
import '../../model/order_model.dart';

abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object> get props => [];
}

class AddOrder extends OrderHistoryEvent {
  final OrderModel order;

  const AddOrder(this.order);

  @override
  List<Object> get props => [order];
}
