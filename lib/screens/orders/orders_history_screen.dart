import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/primary_button.dart';
import 'package:maji_freshi/screens/order/order_tracking_screen.dart';
import 'package:maji_freshi/models/order_model.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Orders',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.text),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.secondary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.secondary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: OrderService(),
        builder: (context, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(isAll: true),
              _buildOrderList(isActive: true),
              _buildOrderList(isCompleted: true),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(
      {bool isAll = false, bool isActive = false, bool isCompleted = false}) {
    final allOrders = OrderService().orders;
    List<OrderModel> filteredOrders = [];

    if (isAll) {
      filteredOrders = allOrders;
    } else if (isActive) {
      filteredOrders = allOrders
          .where((order) =>
              order.status == OrderStatus.placed ||
              order.status == OrderStatus.confirmed ||
              order.status == OrderStatus.outForDelivery)
          .toList();
    } else if (isCompleted) {
      filteredOrders = allOrders
          .where((order) =>
              order.status == OrderStatus.delivered ||
              order.status == OrderStatus.cancelled)
          .toList();
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    String statusText;
    Color statusColor;
    Color statusTextColor;
    Widget actionButton;

    switch (order.status) {
      case OrderStatus.placed:
        statusText = 'Placed';
        statusColor = Colors.blue.shade100;
        statusTextColor = Colors.blue.shade800;
        actionButton = PrimaryButton(
          text: 'Track Order',
          height: 40,
          fontSize: 14,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrderTrackingScreen()),
            );
          },
        );
        break;
      case OrderStatus.confirmed:
        statusText = 'Confirmed';
        statusColor = Colors.blue.shade100;
        statusTextColor = Colors.blue.shade800;
        actionButton = PrimaryButton(
          text: 'Track Order',
          height: 40,
          fontSize: 14,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrderTrackingScreen()),
            );
          },
        );
        break;
      case OrderStatus.outForDelivery:
        statusText = 'On The Way';
        statusColor = Colors.orange.shade100;
        statusTextColor = Colors.orange.shade800;
        actionButton = PrimaryButton(
          text: 'Track Order',
          height: 40,
          fontSize: 14,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrderTrackingScreen()),
            );
          },
        );
        break;
      case OrderStatus.delivered:
        statusText = 'Delivered';
        statusColor = Colors.green.shade100;
        statusTextColor = Colors.green.shade800;
        actionButton = Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Receipt',
                    style: TextStyle(color: AppColors.text)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.secondary.withOpacity(0.1),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Reorder',
                    style: TextStyle(color: AppColors.secondary)),
              ),
            ),
          ],
        );
        break;
      case OrderStatus.cancelled:
        statusText = 'Cancelled';
        statusColor = Colors.red.shade100;
        statusTextColor = Colors.red.shade800;
        actionButton = SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.secondary.withOpacity(0.1),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reorder',
                style: TextStyle(color: AppColors.secondary)),
          ),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                order.formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Order ${order.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.items.length} items · KSH ${order.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          actionButton,
        ],
      ),
    );
  }
}
