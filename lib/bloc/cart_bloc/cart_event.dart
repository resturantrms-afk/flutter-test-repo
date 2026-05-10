import 'package:equatable/equatable.dart';
import 'package:restaurnt_rms/model/menu_item.dart';
import 'package:restaurnt_rms/model/order_item.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final MenuItem menuItem;
  final int quantity;
  AddToCart({required this.menuItem, required this.quantity});
  @override
  List<Object?> get props => [];
}

class RemoveFromCart extends CartEvent {
  final OrderItem itemToRemove;

  RemoveFromCart({required this.itemToRemove});
  @override
  List<Object?> get props => [];
}

class ClearCart extends CartEvent {}
