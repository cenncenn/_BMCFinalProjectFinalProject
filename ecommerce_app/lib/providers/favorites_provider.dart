import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FavoritesProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    _favorites = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();

    notifyListeners();
  }

  Future<void> toggleFavorite(String productId, Map<String, dynamic> productData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId);

    final doc = await favRef.get();

    if (doc.exists) {
      // remove favorite
      await favRef.delete();
      _favorites.removeWhere((item) => item['id'] == productId);
    } else {
      // add favorite
      await favRef.set({
        'name': productData['name'],
        'price': productData['price'],
        'imageUrl': productData['imageUrl'],
      });
      _favorites.add({
        'id': productId,
        ...productData,
      });
    }

    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.any((item) => item['id'] == productId);
  }
}
