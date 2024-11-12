import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nft_app/components/my_button.dart';
import 'package:nft_app/components/my_text_field.dart';
import 'package:nft_app/models/collection.dart';
import 'package:nft_app/models/card.dart' as nft;
import 'package:nft_app/services/firebase_service.dart';


class AddCollectionPage extends StatefulWidget {
  @override
  _AddCollectionPageState createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCollectioncontroller = TextEditingController();
  final List<nft.Card> _cards = [];
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _pickCardImages(int index) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null) return;

    List<String> imageUrls = [];
    for (var image in images) {
      final String imageUrl = await FirebaseService.uploadImage(image);
      imageUrls.add(imageUrl);
    }

    setState(() {
      _cards[index] = nft.Card(
        id: _cards[index].id,
        imageUrl: imageUrls.join(','),
      );
    });
  }

  void _addCard() {
    setState(() {
      _cards.add(nft.Card(id: '', imageUrl: ''));
    });
  }

  void _saveCollection() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final String imageUrl = await FirebaseService.uploadImage(_image!);
      final Collection collection = Collection(
        id: '',
        icone: imageUrl,
        nome: _nameCollectioncontroller.text,
        cards: _cards,
      );
      await FirebaseService.saveCollection(collection);
      Navigator.pop(context, collection);

    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("C R I A R  C O L E Ç Ã O"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyTextField(controller: _nameCollectioncontroller, hintText: "Nome da Coleção", obscureText: false),
                  SizedBox(height: 16),
                  _image == null
                      ? Text('Nenhuma Imagem Selecionada.')
                      : Image.file(File(_image!.path),
                  height: 200,),
                  MyButton(text: "Escolher Imagem", onTap: _pickImage),
                  SizedBox(height: 16),
                  MyButton(text: "Adicionar NFT Cards", onTap: _addCard),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: TextFormField(
                            onChanged: (value) {
                              _cards[index] = nft.Card(
                                id: _cards[index].id,
                                
                                imageUrl: _cards[index].imageUrl,
                              );
                            },
                          ),
                          subtitle: Column(
                            children: [
                              _cards[index].imageUrl.isEmpty
                                  ? Text('Nenhuma Imagem Selecionada.')
                                  : Column(
                                      children: _cards[index]
                                          .imageUrl
                                          .split(',')
                                          .map((url) => Image.network(url))
                                          .toList(),
                                    ),
                              ElevatedButton(
                                onPressed: () => _pickCardImages(index),
                                child: Text('Escolher NFT Card'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  MyButton(text: "Salvar Coleção", onTap: _saveCollection),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
