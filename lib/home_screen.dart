import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_provider.dart';
import 'bottom_chat_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(user!.displayName!),
        actions: [
          TextButton(
            onPressed: () {
              AuthPorvider().signOut();
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Chats(),
            const BottomChatBar(),
          ],
        ),
      ),
    );
  }
}

class Chats extends StatelessWidget {
  Chats({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
      .collection('chats')
      .orderBy('createdAt', descending: false)
      .limit(15)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Flexible(
          child: GestureDetector(
            onTap: () {},
            child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              if (user?.uid == data['owner']) {
                return SentMessage(
                  data: data,
                  sent: true,
                );
              } else {
                return SentMessage(
                  data: data,
                  sent: false,
                );
              }
            }).toList()),
          ),
        );
      },
    );
  }
}

class SentMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool sent;

  const SentMessage({Key? key, required this.data, required this.sent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment:
            sent ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: sent
                  ? [
                      Flexible(
                        child: Text(
                          data['text'],
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          data['image'],
                        ),
                      )
                    ]
                  : [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          data['image'],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          data['text'],
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
