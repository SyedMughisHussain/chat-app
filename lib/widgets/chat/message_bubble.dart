import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MessageBubble(this.message, this.isMe, this.username, {this.key});

  final String message;
  final bool isMe;
  // ignore: annotate_overrides, overridden_fields
  final Key? key;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 160,
          padding: const EdgeInsets.all(8),
          margin: isMe
              ? const EdgeInsets.only(right: 9)
              : const EdgeInsets.only(left: 9),
          decoration: BoxDecoration(
              color: isMe ? Colors.grey[200] : Colors.purple[200],
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0))),
          child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: isMe ? Colors.black : Colors.white, fontSize: 16),
                ),
              ]),
        ),
      ],
    );
  }
}
