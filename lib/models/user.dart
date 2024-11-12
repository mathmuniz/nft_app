class UserProfile {
  final String uid;
  final String name;
  final String username;
  final String email;
  final bool isAdmin;

  UserProfile({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.isAdmin,
  });
  
  factory UserProfile.fromDocument(Map<String, dynamic> doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      email: doc['email'],
      isAdmin: doc['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}