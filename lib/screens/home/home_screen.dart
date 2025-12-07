import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/screens/home/home_content.dart';
import 'package:maji_freshi/screens/orders/orders_history_screen.dart';
import 'package:maji_freshi/screens/profile/profile_screen.dart';
import 'package:maji_freshi/models/cart_model.dart';
import 'package:maji_freshi/screens/order/order_confirmation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    OrdersHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? ListenableBuilder(
              listenable: CartService(),
              builder: (context, child) {
                if (CartService().items.isEmpty) return const SizedBox.shrink();
                return FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const OrderConfirmationScreen()),
                    );
                  },
                  backgroundColor: AppColors.secondary,
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: Text(
                    'View Cart (${CartService().itemCount})',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
