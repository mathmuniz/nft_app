import 'package:flutter/material.dart';
import 'package:nft_app/pages/collection_page.dart';
import '../components/my_drawer_admin.dart';
import '../models/collection.dart';
import '../services/firebase_service.dart';
class RemoveCollectionPage extends StatefulWidget {
  const RemoveCollectionPage({super.key});

  @override
  State<RemoveCollectionPage> createState() => _HomePageState();
}

class _HomePageState extends State<RemoveCollectionPage> {
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

  Future<void> _removeCollection(Collection collection) async {
    await FirebaseService.removeCollection(collection);
    _getCollections();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawerAdmin(),
      appBar: AppBar(
        title: const Text("C O L E Ç Õ E S"),
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
                          IconButton(onPressed: () => _removeCollection(collection) , color: Colors.red, icon: Icon(Icons.delete),),
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