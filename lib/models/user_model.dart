import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String location;
  final String profileImage;
  final List<String> addresses;
  final List<String> paymentMethods;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    this.profileImage = '',
    this.addresses = const [],
    this.paymentMethods = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
      'profileImage': profileImage,
      'addresses': addresses,
      'paymentMethods': paymentMethods,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      location: json['location'],
      profileImage: json['profileImage'] ?? '',
      addresses: List<String>.from(json['addresses'] ?? []),
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
    );
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? location,
    String? profileImage,
    List<String>? addresses,
    List<String>? paymentMethods,
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
    );
  }
}

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal() {
    _loadUser();
  }

  UserModel _currentUser = const UserModel(
    id: 'user_123',
    name: 'John Mwangi',
    phone: '+254 712 345 678',
    email: 'john.mwangi@example.com',
    location: 'Westlands, Nairobi',
    addresses: ['Home - 123 Valley Road', 'Work - Westlands Office'],
    paymentMethods: ['M-Pesa - 0712 345 678'],
  );

  UserModel get currentUser => _currentUser;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_profile');
    if (userJson != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(_currentUser.toJson()));
    notifyListeners();
  }

  void updateProfile({String? name, String? phone, String? email}) {
    _currentUser = _currentUser.copyWith(
      name: name,
      phone: phone,
      email: email,
    );
    _saveUser();
  }

  void addAddress(String address) {
    final updatedAddresses = List<String>.from(_currentUser.addresses)
      ..add(address);
    _currentUser = _currentUser.copyWith(addresses: updatedAddresses);
    _saveUser();
  }

  void removeAddress(int index) {
    final updatedAddresses = List<String>.from(_currentUser.addresses)
      ..removeAt(index);
    _currentUser = _currentUser.copyWith(addresses: updatedAddresses);
    _saveUser();
  }

  void addPaymentMethod(String method) {
    final updatedMethods = List<String>.from(_currentUser.paymentMethods)
      ..add(method);
    _currentUser = _currentUser.copyWith(paymentMethods: updatedMethods);
    _saveUser();
  }

  void removePaymentMethod(int index) {
    final updatedMethods = List<String>.from(_currentUser.paymentMethods)
      ..removeAt(index);
    _currentUser = _currentUser.copyWith(paymentMethods: updatedMethods);
    _saveUser();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    // Reset to default/empty or handle as needed
    notifyListeners();
  }
}
