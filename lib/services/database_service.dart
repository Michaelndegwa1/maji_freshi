import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maji_freshi/models/order_model.dart';
import 'package:maji_freshi/models/product_model.dart';
import 'package:maji_freshi/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _productsCollection =>
      _firestore.collection('products');
  CollectionReference get _ordersCollection => _firestore.collection('orders');

  // --- User Methods ---

  Future<void> saveUser(UserModel user) async {
    await _usersCollection
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Stream<UserModel?> streamUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  // --- Product Methods ---

  Stream<List<ProductModel>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<ProductModel?> getProduct(String id) async {
    DocumentSnapshot doc = await _productsCollection.doc(id).get();
    if (doc.exists) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // --- Order Methods ---

  Future<void> createOrder(OrderModel order) async {
    await _ordersCollection.doc(order.id).set(order.toMap());
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return _ordersCollection.doc(orderId).snapshots().map((doc) {
      if (doc.exists) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  // --- Migration / Admin Methods ---

  Future<void> uploadProduct(ProductModel product) async {
    // Use the product ID as the document ID
    await _productsCollection.doc(product.id).set(product.toMap());
  }
}
