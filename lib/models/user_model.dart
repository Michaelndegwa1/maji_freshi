import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { customer, rider, admin }

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String location;
  final String profileImage;
  final List<String> addresses;
  final List<String> paymentMethods;
  final UserRole role;
  final String? fcmToken;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    this.profileImage = '',
    this.addresses = const [],
    this.paymentMethods = const [],
    this.role = UserRole.customer,
    this.fcmToken,
    this.createdAt,
  });

  // Create from Firestore Document
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      location: data['location'] ?? '',
      profileImage: data['profileImage'] ?? '',
      addresses: List<String>.from(data['addresses'] ?? []),
      paymentMethods: List<String>.from(data['paymentMethods'] ?? []),
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == (data['role'] ?? 'customer'),
        orElse: () => UserRole.customer,
      ),
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
      'profileImage': profileImage,
      'addresses': addresses,
      'paymentMethods': paymentMethods,
      'role': role.toString().split('.').last,
      'fcmToken': fcmToken,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? location,
    String? profileImage,
    List<String>? addresses,
    List<String>? paymentMethods,
    UserRole? role,
    String? fcmToken,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt,
    );
  }
}
