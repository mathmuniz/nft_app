import 'package:flutter/foundation.dart';
import 'package:nft_app/models/user.dart';

import 'database_service.dart';

class DatabaseProvider extends ChangeNotifier {

  final _db = DatabaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);
  
}