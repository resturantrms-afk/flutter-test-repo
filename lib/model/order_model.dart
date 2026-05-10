import 'package:equatable/equatable.dart';
import 'package:restaurnt_rms/model/order_item.dart';

class OrderModel extends Equatable {
  final String id;
  final int tableNumber;
  final List<OrderItem> items;
  final String status;
  final DateTime createdDate;

  const OrderModel({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.status,
    required this.createdDate,
  });

  @override
  List<Object?> get props => [id, tableNumber, items, status, createdDate];

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get totalQuantity =>
      items.fold(0, (quantity, item) => quantity + item.quantity);
}
