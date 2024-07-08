import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection("users");

  Future<User?> signUp(String name, String email, String phoneNum, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user == null){
        throw Exception("User is Null");
      }
      String uid = credential.user!.uid;
      DocumentReference userRef = _userCollection.doc(uid);
      final userData = <String, dynamic>{
        'name': name,
        'email': email,
        'phoneNum': phoneNum,
        'password': password
      };
      await userRef.set(userData);
      return credential.user;
    } catch(e){
      rethrow;
    }
  }

  Future<String?> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['name']; // Mengembalikan nama pengguna dari dokumen pengguna
      }
      return null; // Mengembalikan null jika dokumen pengguna tidak ada
    } catch (e) {
      print('Error getting user name: $e');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }
}
