class Card {
  String id;
  String imageUrl;

  Card({required this.id, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  static Card fromMap(Map<String, dynamic> map) {
    return Card(
      id: map['id'],
      imageUrl: map['imageUrl'],
    );
  }
}