import 'package:equatable/equatable.dart';
import 'package:restaurnt_rms/model/order_item.dart';

class CartState extends Equatable {
  final List<OrderItem> items;

  CartState({required this.items});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  List<Object?> get props => [items];
}
