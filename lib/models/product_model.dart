class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imagePath;
  final String category; // 'Refill', 'New Bottle', 'Dispenser', 'Wholesale'
  final bool isBestSeller;

  const ProductModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.price,
    required this.imagePath,
    required this.category,
    this.isBestSeller = false,
  });
}
