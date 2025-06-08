import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:product_list_app/core/services/product_service.dart';
import 'package:product_list_app/features/products/models/product.dart';
import 'dart:convert';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'product_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  const baseUrl = 'https://fakestoreapi.com';

  setUp(() {
    mockClient = MockClient();
  });

  group('ProductService', () {
    test('fetchProducts returns list of products on success', () async {
      final apiResponse = [
        {
          "id": 1,
          "title": "Test Product",
          "price": 99.99,
          "description": "Test Description",
          "image": "test.jpg",
          "category": "electronics",
          "rating": {"rate": 4.5, "count": 100}
        }
      ];

      when(mockClient.get(Uri.parse('$baseUrl/products')))
          .thenAnswer((_) async => http.Response(json.encode(apiResponse), 200));

      final result = await ProductService.fetchProducts();

      expect(result.length, equals(1));
      expect(result.first.name, equals("Test Product"));
      expect(result.first.description, equals("Test Description"));
      expect(result.first.price, equals(99.99));
      expect(result.first.image, equals("test.jpg"));
    });

    test('fetchProducts throws exception on error', () async {
      when(mockClient.get(Uri.parse('$baseUrl/products')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => ProductService.fetchProducts(), throwsException);
    });

    test('fetchProductDetail returns product details', () async {
      final productDetail = {
        "id": 1,
        "title": "Test Product",
        "price": 99.99,
        "description": "Test Description",
        "image": "test.jpg",
        "category": "electronics",
        "rating": {"rate": 4.5, "count": 100}
      };

      when(mockClient.get(Uri.parse('$baseUrl/products/1')))
          .thenAnswer((_) async => http.Response(json.encode(productDetail), 200));

      final result = await ProductService.fetchProductDetail(1);

      expect(result, equals(productDetail));
    });

    test('fetchCart returns cart details', () async {
      final cartData = {
        "id": 1,
        "userId": 1,
        "date": "2020-03-02T00:00:00.000Z",
        "products": [
          {"productId": 1, "quantity": 4},
          {"productId": 2, "quantity": 1},
        ],
        "__v": 0
      };

      when(mockClient.get(Uri.parse('$baseUrl/carts/1')))
          .thenAnswer((_) async => http.Response(json.encode(cartData), 200));

      final result = await ProductService.fetchCart(1);

      expect(result, equals(cartData));
    });

    test('createCart creates a new cart', () async {
      final cartData = {
        "userId": 1,
        "products": [
          {"productId": 1, "quantity": 2}
        ]
      };

      final response = {
        "id": 11,
        ...cartData
      };

      when(mockClient.post(
        Uri.parse('$baseUrl/carts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cartData),
      )).thenAnswer((_) async => http.Response(json.encode(response), 201));

      final result = await ProductService.createCart(cartData);

      expect(result, equals(response));
    });
  });
}
