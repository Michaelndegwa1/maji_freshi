import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/recent_order_item.dart';
import 'package:maji_freshi/widgets/product_card.dart';
import 'package:maji_freshi/widgets/wholesale_card.dart';
import 'package:maji_freshi/screens/notifications/notifications_screen.dart';
import 'package:maji_freshi/models/cart_model.dart';
import 'package:maji_freshi/models/order_model.dart';
import 'package:maji_freshi/models/product_model.dart';
import 'package:maji_freshi/screens/order/order_tracking_screen.dart';
import 'package:maji_freshi/screens/cart/cart_screen.dart';
import 'package:maji_freshi/services/database_service.dart';
import 'package:maji_freshi/services/auth_service.dart';
import 'package:maji_freshi/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:maji_freshi/screens/profile/profile_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.text),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.secondary,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<UserModel?>(
          stream: dbService.streamUser(AuthService().currentUser?.uid ?? ''),
          builder: (context, snapshot) {
            final user = snapshot.data;
            final userName = user?.name ?? 'Guest';
            final userEmail = user?.email ?? '';
            final userInitials = userName.isNotEmpty
                ? userName.split(' ').take(2).map((e) => e[0]).join()
                : 'G';

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  accountName: Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(userEmail),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      userInitials,
                      style: const TextStyle(
                          fontSize: 24, color: AppColors.primary),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text('My Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderTrackingScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Cart'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('Contact Us'),
                  onTap: () {
                    // TODO: Implement Contact Us
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title:
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await AuthService().signOut();
                    // TODO: Navigate to Login Screen
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: StreamBuilder<UserModel?>(
        stream: dbService.streamUser(AuthService().currentUser?.uid ?? ''),
        builder: (context, userSnapshot) {
          final user = userSnapshot.data;
          final userName = user?.name.split(' ').first ?? 'User';
          final userLocation = user?.location ?? 'Nairobi, Kenya';

          return StreamBuilder<List<ProductModel>>(
            stream: dbService.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data ?? [];
              final refillProducts =
                  products.where((p) => p.category == 'Refill').toList();
              final newBottleProducts =
                  products.where((p) => p.category == 'New Bottle').toList();
              final dispenserProducts =
                  products.where((p) => p.category == 'Dispenser').toList();
              final wholesaleProducts =
                  products.where((p) => p.category == 'Wholesale').toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning, $userName',
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
                          userLocation,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Refills
                    if (refillProducts.isNotEmpty) ...[
                      const Text(
                        'Refillable Bottles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...refillProducts.map((product) => ProductCard(
                            title: product.title,
                            price: 'KSH ${product.price.toStringAsFixed(0)}',
                            imagePath: product.imagePath,
                            isBestSeller: product.isBestSeller,
                            onAdd: (quantity) {
                              CartService().addItem(product.title,
                                  product.price, product.imagePath, quantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Added $quantity x ${product.title} to cart')),
                              );
                            },
                          )),
                      const SizedBox(height: 24),
                    ],

                    // New Bottles
                    if (newBottleProducts.isNotEmpty) ...[
                      const Text(
                        'New Bottles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...newBottleProducts.map((product) => ProductCard(
                            title: product.title,
                            price: 'KSH ${product.price.toStringAsFixed(0)}',
                            imagePath: product.imagePath,
                            isBestSeller: product.isBestSeller,
                            onAdd: (quantity) {
                              CartService().addItem(product.title,
                                  product.price, product.imagePath, quantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Added $quantity x ${product.title} to cart')),
                              );
                            },
                          )),
                      const SizedBox(height: 24),
                    ],

                    // Dispensers
                    if (dispenserProducts.isNotEmpty) ...[
                      const Text(
                        'Dispensers & Equipment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...dispenserProducts.map((product) => ProductCard(
                            title: product.title,
                            price: 'KSH ${product.price.toStringAsFixed(0)}',
                            imagePath: product.imagePath,
                            isBestSeller: product.isBestSeller,
                            onAdd: (quantity) {
                              CartService().addItem(product.title,
                                  product.price, product.imagePath, quantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Added $quantity x ${product.title} to cart')),
                              );
                            },
                          )),
                      const SizedBox(height: 24),
                    ],

                    // Wholesale
                    if (wholesaleProducts.isNotEmpty) ...[
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
                        items: wholesaleProducts,
                        onAdd: (product, quantity) {
                          CartService().addItem(product.title, product.price,
                              product.imagePath, quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Added $quantity x ${product.title} to cart')),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Recent Orders
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
                    StreamBuilder<List<OrderModel>>(
                      stream: dbService
                          .getUserOrders(AuthService().currentUser?.uid ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final orders = snapshot.data ?? [];
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
                              case OrderStatus.pending:
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
                              case OrderStatus.assigned:
                                statusText = 'Rider Assigned';
                                statusColor = Colors.orange;
                                statusIcon = Icons.delivery_dining;
                                actionText = 'TRACK';
                                break;
                              case OrderStatus.out_for_delivery:
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
                                date: DateFormat('MMM d, yyyy')
                                    .format(order.createdAt),
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
              );
            },
          );
        },
      ),
    );
  }
}
