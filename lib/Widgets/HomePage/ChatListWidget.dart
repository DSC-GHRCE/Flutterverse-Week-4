
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MessageBox.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    Key? key,
    required this.user,
    required this.sizeofScreen,
    required this.snapshot,
  }) : super(key: key);

  final User? user;
  final Size sizeofScreen;
  final AsyncSnapshot<QuerySnapshot> snapshot;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.snapshot.data!.docs.map((DocumentSnapshot e){
        bool alignRight = false;
        Map<String,dynamic> data = e.data() as Map<String,dynamic>;
        if(widget.user!.uid == data["owner"]){
          alignRight = true;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: alignRight ? [
              MessageBox(
                sizeofScreen: widget.sizeofScreen,
                data: data,
                alignRight: alignRight,
              ),
              const SizedBox(width: 5),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(data["imageURL"])
                ),
              ),
            ] :
            [
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(data["imageURL"])
                ),
              ),
              const SizedBox(width: 5),
              MessageBox(
                sizeofScreen: widget.sizeofScreen,
                data: data,
                alignRight: alignRight,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}