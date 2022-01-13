import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomChatBar extends StatefulWidget {
  const BottomChatBar({Key? key}) : super(key: key);

  @override
  _BottomChatBarState createState() => _BottomChatBarState();
}

class _BottomChatBarState extends State<BottomChatBar> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference chatsRef = FirebaseFirestore.instance.collection('chats');

  Future sendMessage() async {
    if (textController.text.isNotEmpty) {
      if (textController.text.length < 100) {
        try {
          return chatsRef.doc().set({
            'text': textController.text,
            'owner': user?.uid,
            'image': user?.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          }).then(
            (value) => {
              textController.clear(),
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Message length greater than 100"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Message can't be empty"),
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              constraints: const BoxConstraints(
                maxWidth: 280,
              ),
              child: TextField(
                cursorColor: Colors.red,
                controller: textController,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                onEditingComplete: sendMessage,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "Enter message",
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 0,
                    bottom: 0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45,
              width: 45,
              child: FloatingActionButton(
                onPressed: sendMessage,
                elevation: 10,
                backgroundColor: Colors.red,
                child: const Center(
                  child: Icon(
                    Icons.send,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
