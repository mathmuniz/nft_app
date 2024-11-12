import 'package:nft_app/models/card.dart' as nft;

class Collection {

  String id;
  String icone;
  String nome;
  List<nft.Card> cards;

  Collection(
      {required this.id, required this.icone, required this.nome, required this.cards});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icone': icone,
      'nome': nome,
      'cards': cards.map((card) => card.toMap()).toList(),
    };
  }



  static Collection fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] ?? '',
      icone: map['icone'] ?? '',
      nome: map['nome'] ?? '',
      cards: (map['cards'] as List<dynamic>?)
          ?.map((x) => nft.Card.fromMap(x as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}



