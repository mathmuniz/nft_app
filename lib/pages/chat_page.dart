import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nft_app/components/my_text_field.dart';
import 'package:nft_app/services/auth_service.dart';

import '../services/database/database_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  final AuthService _auth = AuthService();
  bool _isAdmin = false;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  void _checkAdminStatus() async {
    
    final isAdmin = await _auth.userIsAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _messagesCollection.add({
        'text': _controller.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isAdminMessage': _isAdmin, 
        'userId': user?.uid, 
      });
      _controller.clear();
    }
  }

Future<String> _getUserName(String userId) async {
  final userProfile = await DatabaseService().getUserFromFirebase(userId);
  return userProfile?.name ?? 'Unknown';
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('C H A T'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _messagesCollection.orderBy('timestamp').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final bool isAdminMessage = message['isAdminMessage'] ?? false;
                        
                        final String userId = message['userId'] ?? 'Unknown';
          
                        // Pega o nome do usuário com base no UID
                        return FutureBuilder<String>(
                          future: _getUserName(userId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
          
                            final name = snapshot.data!;
          
                            return ListTile(
                              title: Text(
                                '$name',
                                style: TextStyle(
                                  color: isAdminMessage ? Colors.blue : Colors.black, 
                                  fontWeight: isAdminMessage ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                message['text'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, ),

                              ),
                              leading: isAdminMessage
                                  ? const Icon(Icons.admin_panel_settings, color: Colors.blue)
                                  : const Icon(Icons.person, color: Colors.grey),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(controller: _controller, hintText: "Digite sua mensagem...", obscureText: false),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
