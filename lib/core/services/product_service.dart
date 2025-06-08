import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/products/models/product.dart';

class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com';
  static http.Client client = http.Client();

  static Future<List<Product>> fetchProducts() async {    final response = await client.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Product(
        name: item['title'] ?? '',
        description: item['description'] ?? '',
        price: (item['price'] as num?)?.toDouble() ?? 0.0,
        image: item['image'] ?? '',
      )).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  static Future<Map<String, dynamic>> fetchProductDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
        print(response.statusCode);
      print(response.body);
      throw Exception('Error al cargar detalle del producto');
    }
  }

  static Future<Map<String, dynamic>> createCart(Map<String, dynamic> cartData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/carts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cartData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear carrito');
    }
  }

  static Future<Map<String, dynamic>> fetchCart(int cartId) async {
    final response = await client.get(Uri.parse('$baseUrl/carts/$cartId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar carrito');
    }
  }
}
