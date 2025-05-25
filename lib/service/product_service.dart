import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  static Future<Map<String, dynamic>> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
        print(response.statusCode);
      print(response.body);
      throw Exception('Error al cargar detalle del producto');
    }
  }

  static Future<Map<String, dynamic>> createCart(Map<String, dynamic> cartData) async {
    final response = await http.post(
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
    final response = await http.get(Uri.parse('$baseUrl/carts/$cartId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar carrito');
    }
  }
}
