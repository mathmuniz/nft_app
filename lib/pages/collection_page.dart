import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nft_app/models/collection.dart';
import 'package:nft_app/components/nft_carrosel.dart';
import 'package:nft_app/services/firebase_service.dart';


class CollectionPage extends StatelessWidget {
  final Collection collection;

  const CollectionPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(collection.nome),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
              await FirebaseService.addToFavorites(user.uid, collection);
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Coleção adicionada aos favoritos')),
              );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User not logged in')),
              );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NftCarrosel(
          nftImages: collection.cards.map((card) => card.imageUrl).toList(),
        ),
      ),
    );
  }
}