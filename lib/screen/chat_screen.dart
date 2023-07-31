import 'package:chat_app/widgets/chat/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Chat App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          DropdownButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                )
              ],
              onChanged: (value) {
                if (value == 'logout') FirebaseAuth.instance.signOut();
              })
        ],
      ),
      body: const Column(children: [
        Expanded(child: Messages()),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/yKOtWVszUNbxtr1y9Ps2/messages')
                .add({'text': 'Another value enter'});
          },
          child: const Icon(Icons.add)),
    );
  }
}
