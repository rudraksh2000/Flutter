// ignore_for_file: prefer_const_constructors, deprecated_member_use, sort_child_properties_last, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userImage;
  final bool isMe;
  final Key key;

  MessageBubble(
    this.message,
    this.username,
    this.userImage,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.pink[200] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: isMe ? Radius.circular(0) : Radius.circular(14),
                  bottomRight: isMe ? Radius.circular(14) : Radius.circular(0),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1
                                .color),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isMe)
          Positioned(
            top: -5,
            left: 120,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
          ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
