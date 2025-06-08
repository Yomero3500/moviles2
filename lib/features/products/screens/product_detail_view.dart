import 'package:flutter/material.dart';
import '../../cart/models/cart_model.dart';
import '../../products/models/product.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Si tienes imagen, agrega aquí el widget de imagen
            // Center(
            //   child: Image.network(product.image, ...),
            // ),
            SizedBox(height: 16),
            Text(product.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(
              'Precio: \$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Cart.add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} agregado al carrito')),
                );
              },
              child: Text('Agregar al carrito'),
            )
          ],
        ),
      ),
    );
  }
}