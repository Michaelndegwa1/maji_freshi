import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/recent_order_item.dart';
import 'package:maji_freshi/widgets/product_card.dart';
import 'package:maji_freshi/widgets/wholesale_card.dart';
import 'package:maji_freshi/screens/notifications/notifications_screen.dart';
import 'package:maji_freshi/models/cart_model.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.text),
          onPressed: () {},
        ),
        title: const Text(
          'Maji Fresh',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.text),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning, John',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: const [
                Icon(Icons.location_on, size: 16, color: AppColors.secondary),
                SizedBox(width: 4),
                Text(
                  'Westlands, Nairobi',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Refillable Bottles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            ProductCard(
              title: '20L Water Bottle',
              price: 'KSH 250 / refill',
              imagePath: 'assets/images/bottle_20l.png',
              isBestSeller: true,
              onAdd: () {
                CartService().addItem(
                    '20L Water Bottle', 250, 'assets/images/bottle_20l.png', 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
            ),
            ProductCard(
              title: '10L Water Bottle',
              price: 'KSH 150 / refill',
              imagePath: 'assets/images/bottle_10l.png',
              onAdd: () {
                CartService().addItem(
                    '10L Water Bottle', 150, 'assets/images/bottle_10l.png', 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Dispensers & Equipment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            ProductCard(
              title: 'Water Dispenser',
              price: 'From KSH 5,000',
              imagePath: 'assets/images/dispenser.png',
              onAdd: () {
                CartService().addItem(
                    'Water Dispenser', 5000, 'assets/images/dispenser.png', 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Wholesale Packs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            const WholesaleCard(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const RecentOrderItem(
              status: 'Delivered',
              date: 'Today, 10:30 AM',
              items: '2 items',
              statusColor: Colors.green,
              statusIcon: Icons.check_circle,
              actionText: 'REORDER',
            ),
            const RecentOrderItem(
              status: 'In Transit',
              date: 'Yesterday, 4:15 PM',
              items: '1 Item',
              statusColor: Colors.blue,
              statusIcon: Icons.local_shipping,
              actionText: 'TRACK',
            ),
            const RecentOrderItem(
              status: 'Delivered',
              date: 'Oct 24, 9:00 AM',
              items: '5 items',
              statusColor: Colors.grey,
              statusIcon: Icons.history,
              actionText: 'REORDER',
            ),
          ],
        ),
      ),
    );
  }
}
