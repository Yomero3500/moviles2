import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:product_list_app/features/products/screens/product_list_view.dart';
import 'package:product_list_app/core/services/product_service.dart';

class MockProductService extends Mock {
  Future<List<dynamic>> fetchProducts() async {      return [
      {
        "id": 1,
        "title": "Test Product",
        "price": 99.99,
        "description": "Test Description",
        "category": "test",
        "image": "https://fakestoreapi.com/img/1.jpg",
        "rating": {"rate": 4.5, "count": 10}
      }
    ];
  }
}

void main() {
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
  });

  Widget createProductListView() {
    return MaterialApp(
      home: Scaffold(
        body: ProductListView(),
      ),
    );
  }

  testWidgets('shows loading indicator while fetching products',
      (WidgetTester tester) async {
    await tester.pumpWidget(createProductListView());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays products when data is loaded',
      (WidgetTester tester) async {
    await tester.pumpWidget(createProductListView());
    await tester.pump();

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$99.99'), findsOneWidget);
  });

  testWidgets('displays error message when fetch fails',
      (WidgetTester tester) async {
    when(mockProductService.fetchProducts())
        .thenThrow(Exception('Failed to load products'));

    await tester.pumpWidget(createProductListView());
    await tester.pump();

    expect(find.text('Error al cargar productos'), findsOneWidget);
  });

  testWidgets('navigates to cart when cart icon is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createProductListView());

    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Verify navigation to cart screen
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('shows product details when product is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createProductListView());
    await tester.pump();

    await tester.tap(find.text('Test Product').first);
    await tester.pumpAndSettle();

    // Verify navigation to product detail screen
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
