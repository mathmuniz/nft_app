import 'package:flutter/material.dart';
import 'package:nft_app/components/my_drawer_tile.dart';
import 'package:nft_app/pages/chat_page.dart';
import 'package:nft_app/pages/favorite_page.dart';
import 'package:nft_app/services/auth_service.dart';

import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final _auth = AuthService();

  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(Icons.person, size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              const SizedBox(height: 10),
          
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              MyDrawerTile(
                title: "F A V O R I T O S",
                icon: Icons.favorite,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const FavoritePage(favoriteImages: [],),));
                },
              ),

               MyDrawerTile(
                title: "C H A T",
                icon: Icons.chat,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ChatPage(),));
                },
              ),

              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(),));
                },
              ),

              const Spacer(),
              MyDrawerTile(title: "S A I R", icon: Icons.logout, onTap: logout),
            ],
          ),
        ),
      ),
    );
  }
}