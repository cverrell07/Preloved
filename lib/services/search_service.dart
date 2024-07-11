import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> searchProducts(String query) async {
    try {
      QuerySnapshot productSnapshot = await _firestore.collection('products').get();
      QuerySnapshot userSnapshot = await _firestore.collection('users').get();

      String lowerCaseQuery = query.toLowerCase();

      Map<String, dynamic> usersMap = {};
      userSnapshot.docs.forEach((doc) {
        usersMap[doc.id] = doc.data();
      });

      List<DocumentSnapshot> results = productSnapshot.docs.where((doc) {
        String itemName = doc['itemName'] ?? '';
        String userId = doc['userId'] ?? '';
        
        String userName = usersMap[userId]['name'] ?? '';

        return itemName.toLowerCase().contains(lowerCaseQuery) || userName.toLowerCase().contains(lowerCaseQuery);
      }).toList();

      print('Number of documents found: ${results.length}');
      return results;
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
