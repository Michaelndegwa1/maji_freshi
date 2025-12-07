import 'package:flutter/foundation.dart';
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
}

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<OrderModel> _orders = [];
  OrderModel? _currentOrder;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  OrderModel? get currentOrder => _currentOrder;

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
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      if (_currentOrder?.id == orderId) {
        _currentOrder?.status = status;
      }
      notifyListeners();
    }
  }
}
