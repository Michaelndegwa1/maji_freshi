import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/primary_button.dart';
import 'package:maji_freshi/screens/order/order_delivered_screen.dart';
import 'package:maji_freshi/models/order_model.dart';
import 'package:maji_freshi/services/database_service.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String? orderId;
  const OrderTrackingScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    if (orderId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('No order selected')),
      );
    }

    return StreamBuilder<OrderModel?>(
        stream: DatabaseService().streamOrder(orderId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.text),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: const Center(child: Text('Order not found')),
            );
          }

          final order = snapshot.data!;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.text),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Order #${order.id.substring(order.id.length - 4)}',
                style: const TextStyle(
                    color: AppColors.text, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Map Placeholder
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'Map View Placeholder',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Icon(Icons.location_on,
                            size: 40, color: AppColors.secondary),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rider Info
                        if (order.riderId != null)
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(
                                    'assets/images/driver.png'), // Placeholder
                                backgroundColor: Colors.grey,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.riderName ?? 'Rider',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    const Text(
                                      '0722 123 456', // Placeholder phone
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone,
                                    color: AppColors.secondary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat_bubble,
                                    color: AppColors.secondary, size: 20),
                              ),
                            ],
                          )
                        else
                          const Text('Waiting for rider assignment...',
                              style: TextStyle(color: Colors.grey)),

                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'ESTIMATED DELIVERY TIME',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '10:30 AM', // Placeholder
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'ORDER STATUS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimelineItem(
                          title: 'Order Placed',
                          time: DateFormat('hh:mm a').format(order.createdAt),
                          isCompleted: true,
                          isFirst: true,
                        ),
                        _buildTimelineItem(
                          title: 'Order Confirmed',
                          time: '',
                          isCompleted:
                              order.status.index >= OrderStatus.confirmed.index,
                        ),
                        _buildTimelineItem(
                          title: 'Out for Delivery',
                          time: '',
                          isCompleted: order.status.index >=
                              OrderStatus.out_for_delivery.index,
                          isActive:
                              order.status == OrderStatus.out_for_delivery,
                        ),
                        _buildTimelineItem(
                          title: 'Delivered',
                          time: '',
                          isLast: true,
                          isCompleted: order.status == OrderStatus.delivered,
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'ORDER DETAILS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...order.items.map((item) => _buildOrderDetailItem(
                              '${item.quantity} x ${item.title}',
                              'KSH ${item.totalPrice.toStringAsFixed(0)}',
                            )),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.text,
                              ),
                            ),
                            Text(
                              'KSH ${order.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Payment',
                                style: TextStyle(color: Colors.grey)),
                            Text(
                                order.paymentMethod
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'DELIVERY TO',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on,
                                color: AppColors.secondary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Home', // Placeholder
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.deliveryAddress,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Only show cancel if order is pending or confirmed
                        if (order.status == OrderStatus.pending ||
                            order.status == OrderStatus.confirmed)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                final timeDifference =
                                    DateTime.now().difference(order.createdAt);
                                if (timeDifference.inMinutes > 10) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Cannot Cancel Order'),
                                      content: const Text(
                                          'This order cannot be cancelled as the delivery process has already begun (more than 10 minutes have passed).'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Cancel Order'),
                                    content: const Text(
                                        'Are you sure you want to cancel this order?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await DatabaseService()
                                                .cancelOrder(order.id);
                                            if (context.mounted) {
                                              Navigator.pop(
                                                  context); // Close dialog
                                              Navigator.pop(
                                                  context); // Close tracking screen
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Order cancelled')),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              Navigator.pop(
                                                  context); // Close dialog
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Failed to cancel order: $e')),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text('Yes',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                'Cancel Order',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        // Confirm Delivery Button (Only when Out for Delivery)
                        if (order.status == OrderStatus.out_for_delivery) ...[
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: 'Confirm Delivery',
                            onPressed: () async {
                              try {
                                await DatabaseService()
                                    .confirmDelivery(order.id);
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDeliveredScreen(
                                                orderId: order.id)),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to confirm delivery: $e')),
                                  );
                                }
                              }
                            },
                          ),
                        ],

                        // Simulate Delivery Button (For Testing - Show if not delivered/cancelled)
                        if (order.status != OrderStatus.delivered &&
                            order.status != OrderStatus.cancelled &&
                            order.status != OrderStatus.out_for_delivery) ...[
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: 'Simulate Delivery (Test)',
                            color:
                                Colors.grey, // Distinct color for test button
                            onPressed: () async {
                              try {
                                await DatabaseService()
                                    .confirmDelivery(order.id);
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OrderDeliveredScreen()),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to simulate delivery: $e')),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTimelineItem({
    required String title,
    required String time,
    bool isCompleted = false,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: isCompleted ? AppColors.secondary : Colors.grey.shade300,
              ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? AppColors.secondary
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(
                        color: AppColors.secondary.withOpacity(0.3), width: 4)
                    : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 20,
                color: isCompleted ? AppColors.secondary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted || isActive ? AppColors.text : Colors.grey,
                ),
              ),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailItem(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(
          price,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
