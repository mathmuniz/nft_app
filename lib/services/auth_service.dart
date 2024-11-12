import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;
  
  Future<UserCredential> loginEmailPassword(String email, password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
      
    }

    Future<UserCredential> registerEmailPassword(String email, password) async {
      try {
        
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        return userCredential;
      } on FirebaseAuthException catch (e) {
        throw Exception(e.code);
      } 
    }

    Future<void> logout() async {
      await _auth.signOut();
    }


    Future<bool> userIsAdmin () async {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _db.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
        final userMap = userDoc.data() as Map<String, dynamic>;
        return userMap['isAdmin'];
        }
      }
      return false;
    }
      
  }
