import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/primary_button.dart';
import 'package:maji_freshi/screens/order/order_tracking_screen.dart';

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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(isAll: true),
          _buildOrderList(isActive: true),
          _buildOrderList(isCompleted: true),
        ],
      ),
    );
  }

  Widget _buildOrderList(
      {bool isAll = false, bool isActive = false, bool isCompleted = false}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Today',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        if (isAll || isActive)
          _buildOrderItem(
            orderId: '#5678',
            status: 'On The Way',
            statusColor: Colors.orange.shade100,
            statusTextColor: Colors.orange.shade800,
            items: '2 items',
            price: 'KSH 1,250',
            time: '10:30 AM',
            actionButton: PrimaryButton(
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
            ),
          ),
        const SizedBox(height: 24),
        const Text(
          'Yesterday',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        if (isAll || isCompleted)
          _buildOrderItem(
            orderId: '#1234',
            status: 'Delivered',
            statusColor: Colors.green.shade100,
            statusTextColor: Colors.green.shade800,
            items: '1 item',
            price: 'KSH 700',
            time: '02:15 PM',
            actionButton: Row(
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
            ),
          ),
        const SizedBox(height: 24),
        const Text(
          'Last Week',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        if (isAll || isCompleted)
          _buildOrderItem(
            orderId: '#0987',
            status: 'Cancelled',
            statusColor: Colors.red.shade100,
            statusTextColor: Colors.red.shade800,
            items: '3 items',
            price: 'KSH 1,800',
            time: '18 Oct, 09:00 AM',
            actionButton: SizedBox(
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
            ),
          ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String orderId,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String items,
    required String price,
    required String time,
    required Widget actionButton,
  }) {
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
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Order $orderId',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$items · $price',
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
