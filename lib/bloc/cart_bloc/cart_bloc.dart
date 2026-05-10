import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurnt_rms/bloc/cart_bloc/cart_event.dart';
import 'package:restaurnt_rms/bloc/cart_bloc/cart_state.dart';
import 'package:restaurnt_rms/model/order_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(items: [])) {
    on<AddToCart>((event, emit) {
      List<OrderItem> updatedOrders = List.from(state.items);

      int index = updatedOrders.indexWhere(
        (item) => item.menuItem.id == event.menuItem.id,
      );

      if (index >= 0) {
        OrderItem existingItem = updatedOrders[index];
        updatedOrders[index] = existingItem.copyWith(
          quantity: event.quantity + existingItem.quantity,
        );
      } else {
        updatedOrders.add(
          OrderItem(
            id: event.menuItem.id.toString(),
            menuItem: event.menuItem,
            quantity: event.quantity,
            status: 'pending',
            createdDate: DateTime.now(),
          ),
        );
      }

      emit(CartState(items: updatedOrders));
    });

    on<RemoveFromCart>((event, emit) {
      List<OrderItem> updatedOrders = List.from(state.items);

      if (updatedOrders.contains(event.itemToRemove)) {
        updatedOrders.remove(event.itemToRemove);
      }

      emit(CartState(items: updatedOrders));
    });
    on<ClearCart>((event, emit) => emit(CartState(items: [])));
  }
}
