import 'package:flutter/material.dart';
import '../../products/models/product.dart';
import '../models/cart_model.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    final items = Cart.items;

    return Scaffold(
      appBar: AppBar(title: Text('Carrito de Compras')),
      body: items.isEmpty
          ? Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final cartItem = items[index];
                return ListTile(
                  leading: cartItem.product.image.isNotEmpty
                      ? Image.network(
                          cartItem.product.image,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        )
                      : null,
                  title: Text(cartItem.product.name),
                  subtitle: Text(
                    '\$${cartItem.product.price.toStringAsFixed(2)} x ${cartItem.quantity} = \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        Cart.remove(cartItem.product);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Producto eliminado del carrito')),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Total: \$${Cart.total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}