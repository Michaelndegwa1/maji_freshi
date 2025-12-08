class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imagePath;
  final String category; // 'Refill', 'New Bottle', 'Dispenser', 'Wholesale'
  final bool isBestSeller;
  final int stock;
  final String status; // 'available', 'out_of_stock'
  final double rating;
  final int ratingCount;

  const ProductModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.price,
    required this.imagePath,
    required this.category,
    this.isBestSeller = false,
    this.stock = 100,
    this.status = 'available',
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  // Create from Firestore Document
  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? 'Refill',
      isBestSeller: data['isBestSeller'] ?? false,
      stock: data['stock'] ?? 0,
      status: data['status'] ?? 'available',
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
      'isBestSeller': isBestSeller,
      'stock': stock,
      'status': status,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }
}
