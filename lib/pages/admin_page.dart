
import 'package:flutter/material.dart';
import 'package:nft_app/components/my_button.dart';
import 'package:nft_app/components/my_drawer_admin.dart';
import 'package:nft_app/pages/chat_page.dart';

import '../models/collection.dart';
import '../services/firebase_service.dart';
import 'add_collection_page.dart';
import 'remove_collection_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Collection> _collections = [];

  @override
  void initState() {
    super.initState();
    _getCollections();

  }

    void _getCollections() async {
    final List<Collection> collections = await FirebaseService.getCollections();
    setState(() {
      _collections = collections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawerAdmin(),
      appBar: AppBar(
        title: const Text("Admin Page"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(text: 'Adicionar Coleção', onTap: () async {
                final newCollection = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCollectionPage()));
          
                if (newCollection != null) {
                  setState(() {
                    _collections.add(newCollection);
                  });
                }
              } 
              ),
              SizedBox(height: 20),
              MyButton(text: 'Remover Coleção', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RemoveCollectionPage()));
              }),
              SizedBox(height: 20),
              MyButton(text: 'Chat', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
              }),
            ],
          ),
        ),
            ),
      ),
    );
  }
}