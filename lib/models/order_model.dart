import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maji_freshi/models/cart_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  assigned,
  out_for_delivery,
  delivered,
  cancelled
}

enum PaymentStatus { pending, completed, failed }

enum PaymentMethod { mpesa, cash }

class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final List<CartItem> items;
  final double totalAmount;
  final String deliveryAddress;
  final GeoPoint? deliveryLocation;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final String? riderId;
  final String? riderName;
  final DateTime createdAt;
  final List<Map<String, dynamic>>
      timeline; // [{status: 'pending', time: timestamp}]
  final double? rating;
  final String? review;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    this.deliveryLocation,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    required this.paymentMethod,
    this.riderId,
    this.riderName,
    required this.createdAt,
    this.timeline = const [],
    this.rating,
    this.review,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String documentId) {
    return OrderModel(
      id: documentId,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromMap(item))
              .toList() ??
          [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryLocation: data['deliveryLocation'] as GeoPoint?,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (data['status'] ?? 'pending'),
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) =>
            e.toString().split('.').last ==
            (data['paymentStatus'] ?? 'pending'),
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) =>
            e.toString().split('.').last == (data['paymentMethod'] ?? 'cash'),
        orElse: () => PaymentMethod.cash,
      ),
      riderId: data['riderId'],
      riderName: data['riderName'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      timeline: List<Map<String, dynamic>>.from(data['timeline'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      review: data['review'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'deliveryLocation': deliveryLocation,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'riderId': riderId,
      'riderName': riderName,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'timeline': timeline,
      'rating': rating,
      'review': review,
    };
  }
}
