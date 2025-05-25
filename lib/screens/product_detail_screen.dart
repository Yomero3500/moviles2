import 'package:flutter/material.dart';
import '../cart/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['image'],
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(product['description'], style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(
              'Precio: \$${product['price'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Cart.add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['title']} agregado al carrito')),
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