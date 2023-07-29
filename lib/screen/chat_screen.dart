import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Container(
                child: const Text('Hi there'),
              )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/yKOtWVszUNbxtr1y9Ps2/messages')
                .snapshots()
                .listen((data) {
              for (var element in data.docs) {
                print(element['text']);
              }
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
