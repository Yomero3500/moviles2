import '../../products/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class Cart {
  static final List<CartItem> _items = [];

  static void add(Product product) {
    final index = _items.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  static void remove(Product product) {
    final index = _items.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  static List<CartItem> get items => _items;
  static double get total =>
      _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
}
