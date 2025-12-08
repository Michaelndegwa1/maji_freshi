import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/models/user_model.dart';
import 'package:maji_freshi/services/database_service.dart';
import 'package:maji_freshi/screens/home/home_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String userId;
  const PaymentMethodsScreen({super.key, required this.userId});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final DatabaseService _dbService = DatabaseService();

  Future<void> _addPaymentMethod(String newMethod, UserModel user) async {
    final updatedMethods = List<String>.from(user.paymentMethods)
      ..add(newMethod);
    final updatedUser = UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      location: user.location,
      profileImage: user.profileImage,
      addresses: user.addresses,
      paymentMethods: updatedMethods,
      role: user.role,
      fcmToken: user.fcmToken,
      createdAt: user.createdAt,
    );
    await _dbService.saveUser(updatedUser);
  }

  Future<void> _removePaymentMethod(int index, UserModel user) async {
    final updatedMethods = List<String>.from(user.paymentMethods)
      ..removeAt(index);
    final updatedUser = UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      location: user.location,
      profileImage: user.profileImage,
      addresses: user.addresses,
      paymentMethods: updatedMethods,
      role: user.role,
      fcmToken: user.fcmToken,
      createdAt: user.createdAt,
    );
    await _dbService.saveUser(updatedUser);
  }

  void _showAddPaymentMethodDialog(BuildContext context, UserModel user) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., M-Pesa - 0712 345 678',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _addPaymentMethod(controller.text, user);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child:
                const Text('Add', style: TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.text),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: _dbService.streamUser(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return Stack(
            children: [
              if (user.paymentMethods.isEmpty)
                Center(
                  child: Text(
                    'No payment methods added yet.',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: user.paymentMethods.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card,
                              color: AppColors.secondary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              user.paymentMethods[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _removePaymentMethod(index, user),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton(
                  onPressed: () => _showAddPaymentMethodDialog(context, user),
                  backgroundColor: AppColors.secondary,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
