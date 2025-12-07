import 'package:maji_freshi/models/product_model.dart';

class ProductData {
  static const List<ProductModel> products = [
    // Refills
    ProductModel(
      id: 'refill_20l',
      title: '20L Refill',
      description: 'Refill your empty 20L bottle',
      price: 250,
      imagePath: 'assets/images/bottle_20l.png',
      category: 'Refill',
      isBestSeller: true,
    ),
    ProductModel(
      id: 'refill_10l',
      title: '10L Refill',
      description: 'Refill your empty 10L bottle',
      price: 150,
      imagePath: 'assets/images/bottle_10l.png',
      category: 'Refill',
    ),

    // New Bottles
    ProductModel(
      id: 'new_20l',
      title: '20L New Bottle',
      description: 'Brand new 20L bottle with water',
      price: 1000,
      imagePath: 'assets/images/bottle_20l.png',
      category: 'New Bottle',
    ),
    ProductModel(
      id: 'new_10l',
      title: '10L New Bottle',
      description: 'Brand new 10L bottle with water',
      price: 600,
      imagePath: 'assets/images/bottle_10l.png',
      category: 'New Bottle',
    ),

    // Dispensers
    ProductModel(
      id: 'dispenser_standard',
      title: 'Water Dispenser',
      description: 'Standard hot & cold water dispenser',
      price: 5000,
      imagePath: 'assets/images/dispenser.png',
      category: 'Dispenser',
    ),

    // Wholesale
    ProductModel(
      id: 'wholesale_0.5l',
      title: '0.5L (24-Pack)',
      description: '24 bottles of 0.5L water',
      price: 600,
      imagePath: 'assets/images/bottle_20l.png', // Placeholder
      category: 'Wholesale',
    ),
    ProductModel(
      id: 'wholesale_1l',
      title: '1L (12-Pack)',
      description: '12 bottles of 1L water',
      price: 500,
      imagePath: 'assets/images/bottle_20l.png', // Placeholder
      category: 'Wholesale',
    ),
    ProductModel(
      id: 'wholesale_1.5l',
      title: '1.5L (12-Pack)',
      description: '12 bottles of 1.5L water',
      price: 700,
      imagePath: 'assets/images/bottle_20l.png', // Placeholder
      category: 'Wholesale',
    ),
  ];

  static List<ProductModel> getByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
