import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/services/login_or_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/home_page.dart';
import '../pages/admin_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> checkIfAdmin(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return doc.exists && doc.data()?['isAdmin'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return FutureBuilder<bool>(
              future: checkIfAdmin(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const AdminPage();
                } else {
                  return const HomePage();
                }
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}