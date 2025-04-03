import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/cart_item_data.dart';

class CartState {
  final List<CartItemData> cartItems;
  final double totalValue;

  CartState({
    required this.cartItems,
    required this.totalValue,
  });

  CartState.initial()
      : cartItems = [],
        totalValue = 0.0;

  CartState copyWith({
    List<CartItemData>? cartItems,
    double? totalValue,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalValue: totalValue ?? this.totalValue,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  void addToCart(CartItemData item) {
    final existingItemIndex =
        state.cartItems.indexWhere((cartItem) => cartItem.title == item.title);
    final updatedItems = List<CartItemData>.from(state.cartItems);
    if (existingItemIndex != -1) {
      // If item exists, increment its count

      updatedItems[existingItemIndex].count += 1;
      _updateState(updatedItems);
    } else {
      // If item doesn't exist, add it
      updatedItems.add(item);
      _updateState(updatedItems);
    }
  }

  double _calculateTotal(List<CartItemData> items) {
    return items.fold(0.0, (sum, item) => sum + (item.value * item.count));
  }

  void removeFromCart(CartItemData item) {
    final updatedItems = List<CartItemData>.from(state.cartItems)..remove(item);
    emit(state.copyWith(
      cartItems: updatedItems,
      totalValue: _calculateTotal(updatedItems),
    ));
  }

  void removeAllCart() {
    emit(state.copyWith(cartItems: [], totalValue: 0.0));
  }

  void updateItemCount(CartItemData item, int newCount) {
    if (newCount < 1) return;

    final updatedItems = List<CartItemData>.from(state.cartItems);
    final index =
        updatedItems.indexWhere((cartItem) => cartItem.title == item.title);

    if (index != -1) {
      updatedItems[index].count = newCount;
      emit(state.copyWith(
        cartItems: updatedItems,
        totalValue: _calculateTotal(updatedItems),
      ));
    }
  }

  void toggleFavorite(CartItemData item) {
    final updatedItems = List<CartItemData>.from(state.cartItems);
    final index =
        updatedItems.indexWhere((cartItem) => cartItem.title == item.title);

    if (index != -1) {
      updatedItems[index].isFavorite = !updatedItems[index].isFavorite;
      emit(state.copyWith(cartItems: updatedItems));
    }
  }

  void _updateState(List<CartItemData> items) {
    emit(state.copyWith(
      cartItems: items,
      totalValue: _calculateTotal(items),
    ));
  }
}
