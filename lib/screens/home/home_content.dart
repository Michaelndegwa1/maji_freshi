import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/recent_order_item.dart';
import 'package:maji_freshi/widgets/product_card.dart';
import 'package:maji_freshi/widgets/wholesale_card.dart';
import 'package:maji_freshi/screens/notifications/notifications_screen.dart';
import 'package:maji_freshi/models/cart_model.dart';
import 'package:maji_freshi/models/order_model.dart';
import 'package:maji_freshi/screens/order/order_tracking_screen.dart';
import 'package:maji_freshi/screens/cart/cart_screen.dart';
import 'package:maji_freshi/data/product_data.dart';
import 'package:maji_freshi/models/user_model.dart';

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
                const Icon(Icons.shopping_cart_outlined, color: AppColors.text),
                ListenableBuilder(
                  listenable: CartService(),
                  builder: (context, child) {
                    final count = CartService().itemCount;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
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
            Text(
              'Good Morning, ${UserService().currentUser.name.split(' ')[0]}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  UserService().currentUser.location,
                  style: const TextStyle(color: Colors.grey),
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
            ...ProductData.getByCategory('Refill').map((product) => ProductCard(
                  title: product.title,
                  price: 'KSH ${product.price.toStringAsFixed(0)}',
                  imagePath: product.imagePath,
                  isBestSeller: product.isBestSeller,
                  onAdd: (quantity) {
                    CartService().addItem(product.title, product.price,
                        product.imagePath, quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Added $quantity x ${product.title} to cart')),
                    );
                  },
                )),
            const SizedBox(height: 24),
            const Text(
              'New Bottles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            ...ProductData.getByCategory('New Bottle')
                .map((product) => ProductCard(
                      title: product.title,
                      price: 'KSH ${product.price.toStringAsFixed(0)}',
                      imagePath: product.imagePath,
                      isBestSeller: product.isBestSeller,
                      onAdd: (quantity) {
                        CartService().addItem(product.title, product.price,
                            product.imagePath, quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Added $quantity x ${product.title} to cart')),
                        );
                      },
                    )),
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
            ...ProductData.getByCategory('Dispenser')
                .map((product) => ProductCard(
                      title: product.title,
                      price: 'KSH ${product.price.toStringAsFixed(0)}',
                      imagePath: product.imagePath,
                      isBestSeller: product.isBestSeller,
                      onAdd: (quantity) {
                        CartService().addItem(product.title, product.price,
                            product.imagePath, quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Added $quantity x ${product.title} to cart')),
                        );
                      },
                    )),
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
            WholesaleCard(
              items: ProductData.getByCategory('Wholesale'),
              onAdd: (product, quantity) {
                CartService().addItem(
                    product.title, product.price, product.imagePath, quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Added $quantity x ${product.title} to cart')),
                );
              },
            ),
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
            ListenableBuilder(
              listenable: OrderService(),
              builder: (context, child) {
                final orders = OrderService().orders;
                if (orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('No recent orders',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return Column(
                  children: orders.take(3).map((order) {
                    String statusText;
                    Color statusColor;
                    IconData statusIcon;
                    String actionText;

                    switch (order.status) {
                      case OrderStatus.placed:
                        statusText = 'Placed';
                        statusColor = Colors.blue;
                        statusIcon = Icons.access_time;
                        actionText = 'TRACK';
                        break;
                      case OrderStatus.confirmed:
                        statusText = 'Confirmed';
                        statusColor = Colors.blue;
                        statusIcon = Icons.check;
                        actionText = 'TRACK';
                        break;
                      case OrderStatus.outForDelivery:
                        statusText = 'In Transit';
                        statusColor = Colors.blue;
                        statusIcon = Icons.local_shipping;
                        actionText = 'TRACK';
                        break;
                      case OrderStatus.delivered:
                        statusText = 'Delivered';
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                        actionText = 'REORDER';
                        break;
                      case OrderStatus.cancelled:
                        statusText = 'Cancelled';
                        statusColor = Colors.red;
                        statusIcon = Icons.cancel;
                        actionText = 'REORDER';
                        break;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (actionText == 'TRACK') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const OrderTrackingScreen()),
                          );
                        }
                      },
                      child: RecentOrderItem(
                        status: statusText,
                        date: order.formattedDate,
                        items: '${order.items.length} items',
                        statusColor: statusColor,
                        statusIcon: statusIcon,
                        actionText: actionText,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
