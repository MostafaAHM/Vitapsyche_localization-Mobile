import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../widget/cart_item.dart';
import '../cubit/cart_cubit.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;
    
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.cartItems.isEmpty) {
          return Center(
            child: Text(
              localizations.yourCartIsEmpty,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) {
                  final item = state.cartItems[index];
                  return CartItem(
                    onDelete: () {
                      context.read<CartCubit>().removeFromCart(item);
                    },
                    data: item,
                    onUpdateCount: (newCount) {
                      context.read<CartCubit>().updateItemCount(item, newCount);
                    },
                    onToggleFavorite: () {
                      context.read<CartCubit>().toggleFavorite(item);
                    },
                  );
                },
              ),
            ),
            _buildBottomBar(context, state, localizations),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState state,  localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secoundryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.total,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '£${state.totalValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.paymentProductScreen,
                arguments: state.totalValue,
              );
            },
            child: Text(
              localizations.buyNow,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}