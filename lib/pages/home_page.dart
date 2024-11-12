import 'package:flutter/material.dart';
import 'package:nft_app/components/my_drawer.dart';
import 'package:nft_app/pages/collection_page.dart';
import '../models/collection.dart';
import '../services/firebase_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text("H O M E"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          children: [
            ..._collections
                .map((collection) => Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(collection.nome),
                          SizedBox(width: 8,),
                          Icon(Icons.verified, color: Colors.blue, size: 20),
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
          ],
        ),
      ),
    );
  }
}