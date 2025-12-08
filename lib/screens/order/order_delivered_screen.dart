import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maji_freshi/utils/app_colors.dart';
import 'package:maji_freshi/widgets/primary_button.dart';
import 'package:maji_freshi/screens/home/home_screen.dart';
import 'package:maji_freshi/services/database_service.dart';

class OrderDeliveredScreen extends StatefulWidget {
  final String? orderId;
  const OrderDeliveredScreen({super.key, this.orderId});

  @override
  State<OrderDeliveredScreen> createState() => _OrderDeliveredScreenState();
}

class _OrderDeliveredScreenState extends State<OrderDeliveredScreen> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.text),
          onPressed: () => _navigateToHome(context),
        ),
        title: const Text(
          'Rate Your Order',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _navigateToHome(context),
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_shipping,
                  color: AppColors.secondary, size: 60),
            ),
            const SizedBox(height: 32),
            const Text(
              'Order Delivered!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.orderId != null)
              Text(
                'Order #${widget.orderId!.substring(widget.orderId!.length - 4)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'How was your experience?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to rate',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Add a comment (optional)',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: 'SUBMIT RATING',
              isLoading: _isLoading,
              onPressed: () async {
                if (widget.orderId == null) {
                  _navigateToHome(context);
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                try {
                  await DatabaseService().submitOrderRating(
                    widget.orderId!,
                    _rating,
                    _commentController.text,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Thank you for your feedback!')),
                    );
                    _navigateToHome(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit rating: $e')),
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
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View Receipt',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
