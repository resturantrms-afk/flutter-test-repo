import 'package:equatable/equatable.dart';
import 'package:restaurnt_rms/model/menu_item.dart';

class OrderItem extends Equatable {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String status;
  final DateTime createdDate;

  const OrderItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.status,
    required this.createdDate,
  });

  @override
  List<Object?> get props => [id, menuItem, quantity, status, createdDate];

  double get totalPrice => menuItem.price * quantity;

  OrderItem copyWith({
    String? id,
    MenuItem? menuItem,
    int? quantity,
    String? status,
    DateTime? createdDate,
  }) {
    return OrderItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
