import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/primary_button.dart';
import 'package:maji_freshi/screens/payment/mpesa_payment_screen.dart';
import 'package:maji_freshi/models/cart_model.dart';
import 'package:maji_freshi/models/order_model.dart';
import 'package:maji_freshi/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String _selectedPaymentMethod = 'M-Pesa';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    final items = cart.items;
    final total = cart.totalAmount;

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
          'Confirm Order',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORDER SUMMARY',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Your cart is empty'),
                      ),
                    )
                  else
                    ...items.map((item) => _buildOrderItem(
                          item.title,
                          '${item.quantity} x KSH ${item.price.toStringAsFixed(0)}',
                          'KSH ${item.totalPrice.toStringAsFixed(0)}',
                        )),
                  const SizedBox(height: 32),
                  const Text(
                    'DELIVERY ADDRESS',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppColors.secondary),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Home',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.text,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '123 Valley Road, Nairobi, Kenya',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'DELIVERY INSTRUCTIONS',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Add notes for the rider (optional)',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentOption('M-Pesa', 'assets/images/mpesa.png'),
                  const SizedBox(height: 12),
                  _buildPaymentOption('Cash on Delivery', null,
                      icon: Icons.money),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'KSH ${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'PLACE ORDER',
                  isLoading: _isLoading,
                  onPressed: items.isEmpty
                      ? () {}
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // TODO: Get actual user ID and details
                            const userId = 'user_123';
                            const userName = 'John Doe';
                            final orderId =
                                'ORD-${DateTime.now().millisecondsSinceEpoch}';

                            final order = OrderModel(
                              id: orderId,
                              userId: userId,
                              userName: userName,
                              userPhone: '0712345678', // TODO: Get from user
                              items: items,
                              totalAmount: total,
                              status: OrderStatus.pending,
                              createdAt: DateTime.now(),
                              deliveryAddress:
                                  '123 Valley Road, Nairobi, Kenya', // TODO: Get from user
                              paymentMethod: _selectedPaymentMethod == 'M-Pesa'
                                  ? PaymentMethod.mpesa
                                  : PaymentMethod.cash,
                              paymentStatus: PaymentStatus.pending,
                              timeline: [
                                {
                                  'status': 'pending',
                                  'timestamp': Timestamp.now(),
                                  'description': 'Order placed successfully',
                                },
                              ],
                            );

                            await DatabaseService().createOrder(order);
                            CartService().clearCart();

                            if (mounted) {
                              if (_selectedPaymentMethod == 'M-Pesa') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MpesaPaymentScreen(amount: total)),
                                );
                              } else {
                                // Navigate directly to tracking for Cash
                                // TODO: Navigate to OrderTrackingScreen with orderId
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to place order: $e')),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String title, String quantity, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                quantity,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String? imagePath,
      {IconData? icon}) {
    final isSelected = _selectedPaymentMethod == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.secondary, width: 2)
              : null,
        ),
        child: Row(
          children: [
            if (imagePath != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payment, color: Colors.grey),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.green),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}
