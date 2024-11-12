import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nft_app/models/collection.dart';
import 'package:nft_app/pages/collection_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required List<String> favoriteImages});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Collection> _favorites = [];

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future<void> _getFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favorite')
          .doc(user.uid)
          .collection('favorites')
          .get();

      final List<Collection> favorites = querySnapshot.docs
          .map((doc) => Collection.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _favorites = favorites;
      });
    }
  }

  Future<void> _removeFavorite(Collection collection) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('favorite')
          .doc(user.uid)
          .collection('favorites')
          .doc(collection.id)
          .delete();

      _getFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('F A V O R I T O S'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    
      body: _favorites.isEmpty
          ? Center(child: Text('Nenhuma coleção favoritada'))
          : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
                    children: _favorites
              .map((collection) => Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(collection.nome),
                    SizedBox(width: 8),
                    IconButton(onPressed: () => _removeFavorite(collection), icon: const Icon(Icons.delete,
                        color: Colors.red, size: 20),
                    ),
                  ],
                ),
                leading: Image.network(collection.icone),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollectionPage(
                        collection: collection,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
            ],
                    ))
              .toList(),
                  ),
          ),
    );
  }
}
