import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_models.dart';

class FirebaseProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of products (for real-time updates)
  Stream<List<FirebaseProduct>> getProductsStream() {
    return _firestore
        .collection('products')
        .where('stock', isGreaterThan: 0)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FirebaseProduct.fromFirestore(doc))
            .toList());
  }

  // Update the stock of a product
  Future<void> updateProductStock(String productId, int newStock) async {
    await _firestore
        .collection('products')
        .doc(productId)
        .update({'stock': newStock});
  }

  // Get a single product by ID
  Future<FirebaseProduct?> getProduct(String productId) async {
    final doc =
        await _firestore.collection('products').doc(productId).get();
    return doc.exists ? FirebaseProduct.fromFirestore(doc) : null;
  }
}