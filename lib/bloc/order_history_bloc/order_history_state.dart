import 'package:equatable/equatable.dart';
import '../../model/order_model.dart';

class OrderHistoryState extends Equatable {
  final List<OrderModel> orders;

  const OrderHistoryState({this.orders = const []});

  @override
  List<Object> get props => [orders];
}
