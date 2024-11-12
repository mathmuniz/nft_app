import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nft_app/models/collection.dart';
import 'package:nft_app/models/card.dart' as nft;

class FirebaseService {

  // Faz o upload da imagem da coleção
  static Future<String> uploadImage(XFile image) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('collections/${image.name}');
    final UploadTask uploadTask = storageReference.putFile(File(image.path));
    final TaskSnapshot downloadUrl = await uploadTask;
    return await downloadUrl.ref.getDownloadURL();
  }

  // Salva a coleção no Firestore
  static Future<void> saveCollection(Collection collection) async {
    final DocumentReference docRef = FirebaseFirestore.instance.collection('collections').doc();
    collection.id = docRef.id;
    await docRef.set(collection.toMap());

    await _saveCards(collection.id, collection.cards);
  }

  // salvar os cards associados à coleção no Firestore
  static Future<void> _saveCards(String collectionId, List<nft.Card> cards) async {
    final CollectionReference cardsRef = FirebaseFirestore.instance
        .collection('collections')
        .doc(collectionId)
        .collection('cards'); 
    for (var card in cards) {
      final DocumentReference cardDoc = cardsRef.doc();
      card.id = cardDoc.id; 

      await cardDoc.set(card.toMap());
    }
  }

  // Pega todas as coleções salvas no Firestore
  static Future<List<Collection>> getCollections() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('collections').get();
    return querySnapshot.docs.map((doc) => Collection.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  static Future<Collection> removeCollection(Collection collection) async {
    await FirebaseFirestore.instance.collection('collections').doc(collection.id).delete();
    return collection;
  }


  // pegar todos os cards associados a uma coleção específica
  static Future<List<nft.Card>> getCards(String collectionId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('collections')
        .doc(collectionId)
        .collection('cards')
        .get();

    return querySnapshot.docs.map((doc) => nft.Card.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  static Future<void> addToFavorites(String userId, Collection collection) async {
    final userFavoritesRef = FirebaseFirestore.instance.collection('favorite').doc(userId).collection('favorites');
    await userFavoritesRef.doc(collection.id).set(collection.toMap());
  }

}
