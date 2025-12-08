import 'package:flutter/foundation.dart';

class CartItem {
  final String title;
  final double price;
  final int quantity;
  final String imagePath;

  CartItem({
    required this.title,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imagePath: map['imagePath'] ?? '',
    );
  }

  // Keep toJson/fromJson for backward compatibility if needed, or redirect them
  Map<String, dynamic> toJson() => toMap();
  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem.fromMap(json);
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(String title, double price, String imagePath, int quantity) {
    if (quantity <= 0) return;

    // Check if item already exists
    final existingIndex = _items.indexWhere((item) => item.title == title);
    if (existingIndex != -1) {
      final existingItem = _items[existingIndex];
      _items[existingIndex] = CartItem(
        title: title,
        price: price,
        quantity: existingItem.quantity + quantity,
        imagePath: imagePath,
      );
    } else {
      _items.add(CartItem(
        title: title,
        price: price,
        quantity: quantity,
        imagePath: imagePath,
      ));
    }
    notifyListeners();
  }

  void removeItem(String title) {
    _items.removeWhere((item) => item.title == title);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
