import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/models/user_model.dart';
import 'package:maji_freshi/services/database_service.dart';
import 'package:maji_freshi/screens/home/home_screen.dart';

class MyAddressesScreen extends StatefulWidget {
  final String userId;
  const MyAddressesScreen({super.key, required this.userId});

  @override
  State<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen> {
  final DatabaseService _dbService = DatabaseService();

  Future<void> _addAddress(String newAddress, UserModel user) async {
    final updatedAddresses = List<String>.from(user.addresses)..add(newAddress);
    final updatedUser = UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      location: user.location,
      profileImage: user.profileImage,
      addresses: updatedAddresses,
      paymentMethods: user.paymentMethods,
      role: user.role,
      fcmToken: user.fcmToken,
      createdAt: user.createdAt,
    );
    await _dbService.saveUser(updatedUser);
  }

  Future<void> _removeAddress(int index, UserModel user) async {
    final updatedAddresses = List<String>.from(user.addresses)..removeAt(index);
    final updatedUser = UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      location: user.location,
      profileImage: user.profileImage,
      addresses: updatedAddresses,
      paymentMethods: user.paymentMethods,
      role: user.role,
      fcmToken: user.fcmToken,
      createdAt: user.createdAt,
    );
    await _dbService.saveUser(updatedUser);
  }

  void _showAddAddressDialog(BuildContext context, UserModel user) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Home - 123 Valley Road',
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
                await _addAddress(controller.text, user);
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
          'My Addresses',
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

          // Move the FAB here to have access to 'user'
          return Stack(
            children: [
              if (user.addresses.isEmpty)
                Center(
                  child: Text(
                    'No addresses added yet.',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: user.addresses.length,
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
                          const Icon(Icons.location_on,
                              color: AppColors.secondary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              user.addresses[index],
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
                            onPressed: () => _removeAddress(index, user),
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
                  onPressed: () => _showAddAddressDialog(context, user),
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
