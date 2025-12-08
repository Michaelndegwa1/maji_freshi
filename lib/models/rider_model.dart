import 'package:cloud_firestore/cloud_firestore.dart';

class RiderModel {
  final String id;
  final String name;
  final String phone;
  final String vehicleReg;
  final bool isAvailable;
  final GeoPoint? currentLocation;
  final double rating;
  final int totalDeliveries;

  const RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleReg,
    this.isAvailable = true,
    this.currentLocation,
    this.rating = 5.0,
    this.totalDeliveries = 0,
  });

  factory RiderModel.fromMap(Map<String, dynamic> data, String documentId) {
    return RiderModel(
      id: documentId,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      vehicleReg: data['vehicleReg'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      currentLocation: data['currentLocation'] as GeoPoint?,
      rating: (data['rating'] ?? 5.0).toDouble(),
      totalDeliveries: data['totalDeliveries'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'vehicleReg': vehicleReg,
      'isAvailable': isAvailable,
      'currentLocation': currentLocation,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
    };
  }
}
