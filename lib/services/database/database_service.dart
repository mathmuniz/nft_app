import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nft_app/models/user.dart';

class DatabaseService {

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


  // Salva informações do usuario
  Future<void> saveUserInfoInFirebase({required String nome, required String email}) async {

    String uid = _auth.currentUser!.uid;

    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: nome,
      username: username,
      email: email,
      isAdmin: false,
    );

    final userMap = user.toMap();

    await _db.collection('Users').doc(uid).set(userMap);
  }

  // Pega informações do usuario
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('Users').doc(uid).get();
      if (userDoc.exists) {
      return UserProfile.fromDocument(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}