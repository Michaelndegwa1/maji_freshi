import 'package:flutter/material.dart';
import 'package:maji_freshi/utils/app_colors.dart';

class WholesaleCard extends StatelessWidget {
  const WholesaleCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    color: AppColors.secondary, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bottled Water Packs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Available in 0.5L, 1L, 1.5L',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPackOption('0.5L (24-Pack)'),
          const SizedBox(height: 16),
          _buildPackOption('1L (12-Pack)'),
          const SizedBox(height: 16),
          _buildPackOption('1.5L (12-Pack)'),
        ],
      ),
    );
  }

  Widget _buildPackOption(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildQuantityButton(Icons.remove),
              const SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              _buildQuantityButton(Icons.add),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 16, color: Colors.grey.shade700),
      ),
    );
  }
}
