import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maji_freshi/models/cart_model.dart';

enum OrderStatus { placed, confirmed, outForDelivery, delivered, cancelled }

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    this.status = OrderStatus.placed,
  });

  String get formattedDate {
    // Simple formatting for now
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'status': status.index,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      date: DateTime.parse(json['date']),
      status: OrderStatus.values[json['status']],
    );
  }
}

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal() {
    _loadOrders();
  }

  final List<OrderModel> _orders = [];
  OrderModel? _currentOrder;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  OrderModel? get currentOrder => _currentOrder;

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      final List<dynamic> decoded = jsonDecode(ordersJson);
      _orders.clear();
      _orders.addAll(decoded.map((e) => OrderModel.fromJson(e)).toList());

      // Restore current order if it's active
      try {
        _currentOrder = _orders.firstWhere((o) =>
            o.status == OrderStatus.placed ||
            o.status == OrderStatus.confirmed ||
            o.status == OrderStatus.outForDelivery);
      } catch (_) {
        _currentOrder = null;
      }

      notifyListeners();
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_orders.map((o) => o.toJson()).toList());
    await prefs.setString('orders', encoded);
  }

  void createOrder(List<CartItem> items, double totalAmount) {
    final newOrder = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      items: List.from(items),
      totalAmount: totalAmount,
      date: DateTime.now(),
      status: OrderStatus.placed,
    );
    _orders.insert(0, newOrder); // Add to top of list
    _currentOrder = newOrder;
    _saveOrders();
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      if (_currentOrder?.id == orderId) {
        _currentOrder?.status = status;
      }
      _saveOrders();
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }
}
